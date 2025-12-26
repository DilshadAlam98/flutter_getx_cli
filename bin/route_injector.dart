import 'dart:io';
import 'package:path/path.dart' as p;

String toSnakeCase(String input) {
  if (input.isEmpty) return '';
  var result = input.replaceAllMapped(RegExp(r'(.)([A-Z])'), (Match m) {
    return '${m.group(1)}_${m.group(2)}';
  });
  return result.toLowerCase();
}

String lowerCamel(String s) =>
    s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

void main(List<String> args) {
  if (args.length != 2) {
    print('Usage: dart route_injector.dart <FeatureName> <module_path>');
    exit(1);
  }

  final featureName = args[0]; // Login
  final modulePath = args[1]; // auth/login
  final folderName = p.basename(modulePath); // login
  final snakeFolderName = toSnakeCase(folderName);
  final routeConst = lowerCamel(featureName);

  final routesFile = File('lib/app/routes/app_routes.dart');
  final pagesFile = File('lib/app/routes/app_pages.dart');

  if (!routesFile.existsSync() || !pagesFile.existsSync()) {
    print('❌ app_routes.dart or app_pages.dart not found');
    exit(1);
  }

  // ================= app_routes.dart =================

  var routesContent = routesFile.readAsStringSync();
  final routeDefinition = "  static const String $routeConst = '/$modulePath';";
  final existingRouteRegex = RegExp(
    r'^\s*static const String ' + routeConst + r' = .*?;\n?',
    multiLine: true,
  );

  if (routesContent.contains(existingRouteRegex)) {
    routesContent = routesContent.replaceFirst(
      existingRouteRegex,
      '$routeDefinition\n',
    );
    print('✅ Route constant updated');
  } else {
    routesContent = routesContent.replaceFirst(
      RegExp(r'}\s*$'),
      "$routeDefinition\n}\n",
    );
    print('✅ Route constant added');
  }
  routesFile.writeAsStringSync(routesContent);

  // ================= app_pages.dart =================

  var pagesContent = pagesFile.readAsStringSync();

  final bindingImport =
      "import '../modules/$modulePath/bindings/${snakeFolderName}_binding.dart';";
  final viewImport =
      "import '../modules/$modulePath/views/${snakeFolderName}_view.dart';";

  // ---- Add imports safely ----
  if (!pagesContent.contains(bindingImport)) {
    final newImports = '$viewImport\n$bindingImport';
    pagesContent = pagesContent.replaceFirst(
      RegExp(r"part 'app_routes.dart';"),
      "$newImports\n\npart 'app_routes.dart';",
    );
  }

  // ---- Add or Replace GetPage safely ----
  final pageBlock =
      '''    GetPage(\n      name: AppRoutes.$routeConst,\n      page: () => const ${featureName}View(),\n      binding: ${featureName}Binding(),\n    ),''';
  final existingGetPageRegex = RegExp(
    r'\s*GetPage\([\s\S]*?name:\s*AppRoutes\.' +
        routeConst +
        r'[\s\S]*?\),?\n?',
  );

  if (pagesContent.contains(existingGetPageRegex)) {
    pagesContent = pagesContent.replaceFirst(existingGetPageRegex, pageBlock);
    print('✅ GetPage updated');
  } else {
    pagesContent = pagesContent.replaceFirstMapped(
      RegExp(r'(static final routes\s*=\s*\[)([\s\S]*)(\s*\];)'),
      (match) {
        String listContent = match.group(2)!;
        if (listContent.trim().isNotEmpty &&
            !listContent.trim().endsWith(',')) {
          listContent = '$listContent,';
        }
        return '${match.group(1)}$listContent\n$pageBlock\n${match.group(3)}';
      },
    );
    print('✅ GetPage injected');
  }

  pagesFile.writeAsStringSync(pagesContent);
}
