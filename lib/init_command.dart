import 'dart:io';
import 'package:path/path.dart' as p;

void initProject() {
  print("🚀 Initializing Core Structure...");
  final coreDir = Directory('lib/app/core');
  if (coreDir.existsSync()) {
    print(
      "⚠️  Core directory already exists. Skipping initialization to avoid overwriting.",
    );
  } else {
    _createDirectories();
    _createComponents();
    _createTheme();
    _createUtils();
  }
  _createConfig();
  _createLocalConfig();
  _createConstants();
  _createDialogUtils();
  _ensureDependencies();
  print("✅ Core Structure Initialized");
}

void _createDirectories() {
  final dirs = [
    'lib/app/core/components',
    'lib/app/core/theme',
    'lib/app/core/utils',
    'lib/app/core/constants',
    'lib/app/config/local',
  ];
  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
    print("   Created directory: $dir");
  }
}

void _createComponents() {
  final componentsDir = 'lib/app/core/components';
  File(p.join(componentsDir, 'primary_button.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final TextStyle? textStyle;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: textStyle ?? const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
''');

  File(p.join(componentsDir, 'primary_textfield.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PrimaryTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
''');

  File(p.join(componentsDir, 'primary_dropdown.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';

class PrimaryDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? hintText;
  final String? Function(T?)? validator;

  const PrimaryDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
''');
}

void _createTheme() {
  final themeDir = 'lib/app/core/theme';
  File(p.join(themeDir, 'app_colors.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const secondary = Color(0xFFFFC107);
  static const background = Color(0xFFF5F5F5);
  static const surface = Colors.white;
  static const error = Color(0xFFB00020);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
}
''');

  File(p.join(themeDir, 'text_styles.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  static const bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
''');

  File(p.join(themeDir, 'app_theme.dart')).writeAsStringSync('''
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static final light = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        textStyle: AppTextStyles.button,
      ),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Color(0xFF1E1E1E),
      error: AppColors.error,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        textStyle: AppTextStyles.button,
      ),
    ),
  );
}
''');
}

void _createUtils() {
  final utilsDir = 'lib/app/core/utils';
  final appUtilsFile = File(p.join(utilsDir, 'app_utils.dart'));
  if (!appUtilsFile.existsSync()) {
    appUtilsFile.writeAsStringSync('''
import 'package:get/get.dart';

class AppUtils {
  static bool isEmail(String s) => GetUtils.isEmail(s);
  static bool isPhoneNumber(String s) => GetUtils.isPhoneNumber(s);
  static bool isDateTime(String s) => GetUtils.isDateTime(s);
  static bool isMD5(String s) => GetUtils.isMD5(s);
  static bool isSHA1(String s) => GetUtils.isSHA1(s);
  static bool isSHA256(String s) => GetUtils.isSHA256(s);
  static bool isBinary(String s) => GetUtils.isBinary(s);
  static bool isIPv4(String s) => GetUtils.isIPv4(s);
  static bool isIPv6(String s) => GetUtils.isIPv6(s);
  static bool isHexadecimal(String s) => GetUtils.isHexadecimal(s);
  static bool isPalindrom(String s) => GetUtils.isPalindrom(s);
  static bool isPassport(String s) => GetUtils.isPassport(s);
  static bool isCurrency(String s) => GetUtils.isCurrency(s);
  static bool isCpf(String s) => GetUtils.isCpf(s);
  static bool isCnpj(String s) => GetUtils.isCnpj(s);
  static bool isCaseInsensitiveContains(String a, String b) => GetUtils.isCaseInsensitiveContains(a, b);
  static bool isCaseInsensitiveContainsAny(String a, String b) => GetUtils.isCaseInsensitiveContainsAny(a, b);
  static String? capitalize(String s) => GetUtils.capitalize(s);
  static String? capitalizeFirst(String s) => GetUtils.capitalizeFirst(s);
  static String removeAllWhitespace(String s) => GetUtils.removeAllWhitespace(s);
  static String? camelCase(String s) => GetUtils.camelCase(s);
  static String? paramCase(String s) => GetUtils.paramCase(s);
  static String numericOnly(String s, {bool firstWordOnly = false}) => GetUtils.numericOnly(s, firstWordOnly: firstWordOnly);
  static bool isNull(dynamic value) => GetUtils.isNull(value);
  static bool isNullOrBlank(dynamic value) => GetUtils.isNullOrBlank(value) ?? true;
  static bool isBlank(dynamic value) => GetUtils.isBlank(value) ?? true;
  static bool isLengthAh(dynamic value, int length) => GetUtils.isLengthEqualTo(value, length);
  static bool hasMatch(String? value, String pattern) => GetUtils.hasMatch(value, pattern);
  static bool isImage(String path) => GetUtils.isImage(path);
  static bool isAudio(String path) => GetUtils.isAudio(path);
  static bool isVideo(String path) => GetUtils.isVideo(path);
  static bool isTxt(String path) => GetUtils.isTxt(path);
  static bool isExcel(String path) => GetUtils.isExcel(path);
  static bool isPPT(String path) => GetUtils.isPPT(path);
  static bool isAPK(String path) => GetUtils.isAPK(path);
  static bool isPDF(String path) => GetUtils.isPDF(path);
  static bool isHTML(String path) => GetUtils.isHTML(path);
}
''');
  }
}

void _createConfig() {
  final baseDir = 'lib/app/config/network';
  Directory(baseDir).createSync(recursive: true);
  Directory(p.join(baseDir, 'interceptors')).createSync(recursive: true);

  // API Constants
  final apiConstantsFile = File(p.join(baseDir, 'api_constants.dart'));
  if (!apiConstantsFile.existsSync()) {
    apiConstantsFile.writeAsStringSync('''
class ApiConstants {
  static const String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';
}
''');
  }

  // Dio Client
  final dioClientSrc = [
    "import 'package:dio/dio.dart';",
    "import 'interceptors/auth_interceptor.dart';",
    "import 'interceptors/logger_interceptor.dart';",
    "",
    "class DioClient {",
    "  static final DioClient _instance = DioClient._internal();",
    "  factory DioClient() => _instance;",
    "",
    "  late final Dio dio;",
    "",
    "  DioClient._internal() {",
    "    final options = BaseOptions(",
    "      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: ''),",
    "      connectTimeout: const Duration(seconds: 30),",
    "      receiveTimeout: const Duration(seconds: 30),",
    "      headers: {",
    "        'Content-Type': 'application/json',",
    "        'Accept': 'application/json',",
    "      },",
    "    );",
    "    dio = Dio(options);",
    "    dio.interceptors.addAll([",
    "      LoggerInterceptor(),",
    "      AuthInterceptor(tokenProvider: () async {",
    "        // TODO: Provide auth token here",
    "        return null;",
    "      }),",
    "    ]);",
    "  }",
    "}",
  ].join('\n');
  File(p.join(baseDir, 'dio_client.dart')).writeAsStringSync(dioClientSrc);

  // Logger Interceptor
  final loggerInterceptorSrc = [
    "import 'package:dio/dio.dart';",
    "",
    "class LoggerInterceptor extends Interceptor {",
    "  @override",
    "  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {",
    "    // print('➡️  REQUEST: ' + options.method + ' ' + options.uri.toString());",
    "    handler.next(options);",
    "  }",
    "",
    "  @override",
    "  void onResponse(Response response, ResponseInterceptorHandler handler) {",
    "    // print('✅ RESPONSE: ' + (response.statusCode?.toString() ?? '-') + ' ' + response.realUri.toString());",
    "    handler.next(response);",
    "  }",
    "",
    "  @override",
    "  void onError(DioException err, ErrorInterceptorHandler handler) {",
    "    // print('❌ ERROR: ' + (err.response?.statusCode?.toString() ?? '-') + ' ' + (err.message ?? '-'));",
    "    handler.next(err);",
    "  }",
    "}",
  ].join('\n');
  File(
    p.join(baseDir, 'interceptors', 'logger_interceptor.dart'),
  ).writeAsStringSync(loggerInterceptorSrc);

  // Auth Interceptor
  final authInterceptorSrc = [
    "import 'package:dio/dio.dart';",
    "",
    "typedef TokenProvider = Future<String?> Function();",
    "",
    "class AuthInterceptor extends Interceptor {",
    "  final TokenProvider tokenProvider;",
    "",
    "  AuthInterceptor({required this.tokenProvider});",
    "",
    "  @override",
    "  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {",
    "    final token = await tokenProvider();",
    "    if (token != null && token.isNotEmpty) {",
    "      options.headers['Authorization'] = 'Bearer ' + token;",
    "    }",
    "    handler.next(options);",
    "  }",
    "}",
  ].join('\n');
  File(
    p.join(baseDir, 'interceptors', 'auth_interceptor.dart'),
  ).writeAsStringSync(authInterceptorSrc);
}

void _createLocalConfig() {
  final localDir = 'lib/app/config/local';
  Directory(localDir).createSync(recursive: true);

  final prefsFile = File(p.join(localDir, 'shared_prefs.dart'));
  if (!prefsFile.existsSync()) {
    prefsFile.writeAsStringSync('''
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();
  static final SharedPrefs instance = SharedPrefs._();

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  Future<bool> setString(String key, String value) async =>
      (await _prefs()).setString(key, value);
  Future<String?> getString(String key) async =>
      (await _prefs()).getString(key);

  Future<bool> setInt(String key, int value) async =>
      (await _prefs()).setInt(key, value);
  Future<int?> getInt(String key) async => (await _prefs()).getInt(key);

  Future<bool> setBool(String key, bool value) async =>
      (await _prefs()).setBool(key, value);
  Future<bool?> getBool(String key) async => (await _prefs()).getBool(key);

  Future<bool> setDouble(String key, double value) async =>
      (await _prefs()).setDouble(key, value);
  Future<double?> getDouble(String key) async =>
      (await _prefs()).getDouble(key);

  Future<bool> setStringList(String key, List<String> value) async =>
      (await _prefs()).setStringList(key, value);
  Future<List<String>?> getStringList(String key) async =>
      (await _prefs()).getStringList(key);

  Future<bool> remove(String key) async => (await _prefs()).remove(key);
  Future<bool> clear() async => (await _prefs()).clear();

  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    final jsonStr = jsonEncode(value);
    return (await _prefs()).setString(key, jsonStr);
  }

  Future<Map<String, dynamic>?> getObject(String key) async {
    final str = (await _prefs()).getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> setTypedObject<T>(String key, T value, Map<String, dynamic> Function(T) toJson) async {
    return setObject(key, toJson(value));
  }

  Future<T?> getTypedObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final map = await getObject(key);
    if (map == null) return null;
    return fromJson(map);
  }
}
''');
  }
}

void _createConstants() {
  final constantsDir = 'lib/app/core/constants';
  Directory(constantsDir).createSync(recursive: true);

  final appConstantsFile = File(p.join(constantsDir, 'app_constants.dart'));
  if (!appConstantsFile.existsSync()) {
    appConstantsFile.writeAsStringSync('''
class AppConstants {
  static const String appName = 'Flutter GetX App';
  static const String version = '1.0.0';
}
''');
  }

  final stringConstantsFile = File(
    p.join(constantsDir, 'string_constants.dart'),
  );
  if (!stringConstantsFile.existsSync()) {
    stringConstantsFile.writeAsStringSync('''
class StringConstants {
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
}
''');
  }

  final globalConstantsFile = File(
    p.join(constantsDir, 'global_constants.dart'),
  );
  if (!globalConstantsFile.existsSync()) {
    globalConstantsFile.writeAsStringSync('''
// Add global (top-level) constants here
const int defaultTimeoutSeconds = 30;
''');
  }
}

void _createDialogUtils() {
  final utilsDir = 'lib/app/core/utils';
  Directory(utilsDir).createSync(recursive: true);

  final dialogUtils = File(p.join(utilsDir, 'dialog_utils.dart'));
  if (!dialogUtils.existsSync()) {
    dialogUtils.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static Future<void> showLoading({String? message}) async {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(message),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
''');
  }
}

void _ensureDependencies() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print("⚠️  pubspec.yaml not found. Skipping dependency installation.");
    return;
  }
  try {
    final res1 = Process.runSync('flutter', ['pub', 'add', 'dio']);
    final res2 = Process.runSync('flutter', ['pub', 'add', 'get']);
    final res3 = Process.runSync('flutter', [
      'pub',
      'add',
      'shared_preferences',
    ]);
    if (res1.exitCode == 0 && res2.exitCode == 0 && res3.exitCode == 0) {
      print("📦 Added dependencies: dio, get, shared_preferences");
      return;
    }
  } catch (_) {
    // Fall through to manual injection
  }

  // Manual injection fallback
  var content = pubspec.readAsStringSync();
  if (!content.contains('\ndependencies:')) {
    content += '\ndependencies:\n';
  }
  if (!content.contains('\n  dio:')) {
    content = content.replaceFirst(
      '\ndependencies:\n',
      '\ndependencies:\n  dio: ^5.4.0\n',
    );
  }
  if (!content.contains('\n  get:')) {
    content = content.replaceFirst(
      '\ndependencies:\n',
      '\ndependencies:\n  get: ^4.6.6\n',
    );
  }
  if (!content.contains('\n  shared_preferences:')) {
    content = content.replaceFirst(
      '\ndependencies:\n',
      '\ndependencies:\n  shared_preferences: ^2.2.2\n',
    );
  }
  pubspec.writeAsStringSync(content);
  print(
    "📦 Ensured dependencies in pubspec.yaml: dio, get, shared_preferences",
  );
}
