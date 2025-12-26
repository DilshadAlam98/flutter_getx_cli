class ApiConstants {
  static const String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';
}
