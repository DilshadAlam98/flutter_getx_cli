#!/usr/bin/env dart

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_getx_cli/init_command.dart';

// TODO: find a better way to do this
const _baseModulesDir = "lib/app/modules";

void main(List<String> args) {
  if (args.isEmpty) {
    print("Usage: getx_cli <command> [options]");
    exit(1);
  }

  final command = args[0];

  switch (command) {
    case 'init':
      initProject();
      break;
    case 'create':
      _createModule(args);
      break;
    case 'remove':
      _removeModule(args);
      break;
    default:
      print('Unknown command: $command');
      exit(1);
  }
}

void _createModule(List<String> args) {
  if (args.length < 2) {
    print('Usage: getx_cli create <module_path> [--no-route]');
    exit(1);
  }

  final modulePath = args[1];
  final createRoute = !args.contains('--no-route');
  final featureName = p.basename(modulePath);

  final className = _toUpperCamelCase(featureName);
  final snakeName = _toSnakeCase(featureName);
  final moduleDir = p.join(_baseModulesDir, modulePath);

  if (Directory(moduleDir).existsSync()) {
    print('❌ Module already exists: $modulePath');
    exit(1);
  }

  print("📦 Creating module: $className");

  Directory(p.join(moduleDir, 'bindings')).createSync(recursive: true);
  Directory(p.join(moduleDir, 'controllers')).createSync(recursive: true);
  Directory(p.join(moduleDir, 'views')).createSync(recursive: true);

  // Controller
  File(
    p.join(moduleDir, 'controllers', '${snakeName}_controller.dart'),
  ).writeAsStringSync('''
import 'package:get/get.dart';

class ${className}Controller extends GetxController {}
''');

  // Binding
  File(
    p.join(moduleDir, 'bindings', '${snakeName}_binding.dart'),
  ).writeAsStringSync('''
import 'package:get/get.dart';
import '../controllers/${snakeName}_controller.dart';

class ${className}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${className}Controller>(() => ${className}Controller());
  }
}
''');

  // View
  File(p.join(moduleDir, 'views', '${snakeName}_view.dart')).writeAsStringSync(
    '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/${snakeName}_controller.dart';

class ${className}View extends GetView<${className}Controller> {
  const ${className}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$className')),
      body: const Center(child: Text('$className View')),
    );
  }
}
''',
  );

  print("✅ Files created");

  if (createRoute) {
    print("🔗 Injecting routes...");
    _injectRoute(className, modulePath);
  }

  print("🎉 Done");
}

void _removeModule(List<String> args) {
  if (args.length < 2) {
    print('Usage: getx_cli remove <module_path> [--routes-only]');
    exit(1);
  }

  final modulePath = args[1];
  final routesOnly = args.contains('--routes-only');
  final featureName = p.basename(modulePath);
  final className = _toUpperCamelCase(featureName);
  final moduleDir = p.join(_baseModulesDir, modulePath);

  if (!routesOnly) {
    print("🗑 Removing module directory...");
    Directory(moduleDir).deleteSync(recursive: true);
  }

  print("🧹 Removing routes...");
  _removeRoute(className, modulePath);

  print("✅ Done");
}

void _injectRoute(String featureName, String modulePath) {
  final folderName = p.basename(modulePath);
  final snakeFolderName = _toSnakeCase(folderName);
  final routeConst = _lowerCamel(featureName);

  final routesDir = Directory('lib/app/routes');
  final routesFile = File(p.join(routesDir.path, 'app_routes.dart'));
  final pagesFile = File(p.join(routesDir.path, 'app_pages.dart'));

  if (!routesDir.existsSync()) {
    print('✨ Creating routes directory...');
    routesDir.createSync(recursive: true);
  }

  if (!routesFile.existsSync()) {
    print('✨ Creating app_routes.dart...');
    routesFile.writeAsStringSync(_appRoutesTemplate);
  }

  if (!pagesFile.existsSync()) {
    print('✨ Creating app_pages.dart...');
    pagesFile.writeAsStringSync(_appPagesTemplate);
  }

  // app_routes.dart
  var routesContent = routesFile.readAsStringSync();
  if (routesContent.contains('static const String $routeConst')) {
    print('⚠️ Route constant already exists in app_routes.dart');
  } else {
    routesContent = routesContent.replaceFirst(
      RegExp(r'}\s*$'),
      "  static const String $routeConst = '/$modulePath';\n}\n",
    );
    routesFile.writeAsStringSync(routesContent);
    print('✅ Route constant added to app_routes.dart');
  }

  // app_pages.dart
  var pagesContent = pagesFile.readAsStringSync();
  final bindingImport =
      "import '../modules/$modulePath/bindings/${snakeFolderName}_binding.dart';";
  final viewImport =
      "import '../modules/$modulePath/views/${snakeFolderName}_view.dart';";

  if (!pagesContent.contains(bindingImport)) {
    pagesContent = pagesContent.replaceFirst(
      RegExp(r"part 'app_routes.dart';"),
      "$viewImport\n$bindingImport\n\npart 'app_routes.dart';",
    );
  }

  if (pagesContent.contains('name: AppRoutes.$routeConst')) {
    print('⚠️ GetPage entry already exists in app_pages.dart');
  } else {
    final pageBlock =
        '''
    GetPage(
      name: AppRoutes.$routeConst,
      page: () => const ${featureName}View(),
      binding: ${featureName}Binding(),
    ),''';

    if (pagesContent.contains('static final pages = <GetPage>[];')) {
      pagesContent = pagesContent.replaceFirst(
        'static final pages = <GetPage>[];',
        'static final pages = <GetPage>[\n$pageBlock\n];',
      );
    } else {
      pagesContent = pagesContent.replaceFirst(
        RegExp(r'\]\s*;'),
        '\n$pageBlock\n];',
      );
    }
    pagesFile.writeAsStringSync(pagesContent);
    print('✅ Page injected');
  }
}

void _removeRoute(String featureName, String modulePath) {
  final route = _lowerCamel(featureName);
  final folder = p.basename(modulePath);

  final routesFile = File('lib/app/routes/app_routes.dart');
  final pagesFile = File('lib/app/routes/app_pages.dart');

  if (routesFile.existsSync()) {
    var c = routesFile.readAsStringSync();
    c = c.replaceAll(
      RegExp(
        r'^\s*static const String ' + route + r' = .*?;\n',
        multiLine: true,
      ),
      '',
    );
    routesFile.writeAsStringSync(c);
  }

  if (pagesFile.existsSync()) {
    var c = pagesFile.readAsStringSync();
    c = c.replaceAll(
      RegExp(r'\s*GetPage\([\s\S]*?AppRoutes\.' + route + r'[\s\S]*?\n\s*\),'),
      '',
    );

    final snakeFolder = _toSnakeCase(folder);
    c = c.replaceAll(
      RegExp(r"import .*?/" + snakeFolder + r"_binding.dart';\n?"),
      '',
    );
    c = c.replaceAll(
      RegExp(r"import .*?/" + snakeFolder + r"_view.dart';\n?"),
      '',
    );

    pagesFile.writeAsStringSync(c);
  }
}

String _toSnakeCase(String input) {
  if (input.isEmpty) return '';
  return input
      .replaceAllMapped(RegExp(r'(.)([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .toLowerCase();
}

String _toUpperCamelCase(String str) {
  return str.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join();
}

String _lowerCamel(String s) =>
    s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

const _appRoutesTemplate = '''part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();
}
''';

const _appPagesTemplate = '''import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[];
}
''';
