import 'dart:io';
import 'package:path/path.dart' as p;

String toSnakeCase(String input) {
  if (input.isEmpty) return '';
  return input
      .replaceAllMapped(RegExp(r'(.)([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .toLowerCase();
}

String lowerCamel(String s) =>
    s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

void injectRoute(String featureName, String modulePath) {
  final folderName = p.basename(modulePath);
  final snakeFolderName = toSnakeCase(folderName);
  final routeConst = lowerCamel(featureName);

  final routesFile = File('lib/app/routes/app_routes.dart');
  final pagesFile = File('lib/app/routes/app_pages.dart');

  if (!routesFile.existsSync() || !pagesFile.existsSync()) {
    throw Exception('Routes files not found');
  }

  var routesContent = routesFile.readAsStringSync();
  if (!routesContent.contains('static const String $routeConst')) {
    routesContent = routesContent.replaceFirst(
      RegExp(r'}\s*$'),
      "  static const String $routeConst = '/$modulePath';\n}\n",
    );
    routesFile.writeAsStringSync(routesContent);
  }

  var pagesContent = pagesFile.readAsStringSync();

  final bindingImport =
      "import '../modules/$modulePath/bindings/${snakeFolderName}_binding.dart';";
  final viewImport =
      "import '../modules/$modulePath/views/${snakeFolderName}_view.dart';";

  if (!pagesContent.contains(bindingImport)) {
    pagesContent = "$viewImport\n$bindingImport\n$pagesContent";
  }

  if (!pagesContent.contains('AppRoutes.$routeConst')) {
    pagesContent = pagesContent.replaceFirst(
      RegExp(r'pages\s*=\s*\['),
      '''pages = [\n    GetPage(\n      name: AppRoutes.$routeConst,\n      page: () => const ${featureName}View(),\n      binding: ${featureName}Binding(),\n    ),\n''',
    );
  }

  pagesFile.writeAsStringSync(pagesContent);
}
