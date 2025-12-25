import 'dart:io';
import 'package:path/path.dart' as p;

String lowerCamel(String s) =>
    s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

void removeRoute(String feature, String modulePath) {
  final route = lowerCamel(feature);
  final folder = p.basename(modulePath);

  final routesFile = File('lib/app/routes/app_routes.dart');
  final pagesFile = File('lib/app/routes/app_pages.dart');

  if (routesFile.existsSync()) {
    var c = routesFile.readAsStringSync();
    c = c.replaceAll(
      RegExp(r'^\s*static const String ' + route + r' = .*?;', multiLine: true),
      '',
    );
    routesFile.writeAsStringSync(c);
  }

  if (pagesFile.existsSync()) {
    var c = pagesFile.readAsStringSync();

    c = c.replaceAll(
      RegExp(r'\s*GetPage\([\s\S]*?AppRoutes\.' + route + r'[\s\S]*?\),'),
      '',
    );

    c = c.replaceAll(
      RegExp(r"import .*?/modules/.*/bindings/${folder}_binding.dart';\n?"),
      '',
    );
    c = c.replaceAll(
      RegExp(r"import .*?/modules/.*/views/${folder}_view.dart';\n?"),
      '',
    );

    pagesFile.writeAsStringSync(c);
  }
}
