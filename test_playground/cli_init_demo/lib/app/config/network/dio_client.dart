import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._internal() {
    final options = BaseOptions(
      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: ''),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    dio = Dio(options);
    dio.interceptors.addAll([
      LoggerInterceptor(),
      AuthInterceptor(tokenProvider: () async {
        // TODO: Provide auth token here
        return null;
      }),
    ]);
  }
}