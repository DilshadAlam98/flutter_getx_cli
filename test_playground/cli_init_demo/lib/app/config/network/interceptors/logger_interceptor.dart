import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print('➡️  REQUEST: ' + options.method + ' ' + options.uri.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print('✅ RESPONSE: ' + (response.statusCode?.toString() ?? '-') + ' ' + response.realUri.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // print('❌ ERROR: ' + (err.response?.statusCode?.toString() ?? '-') + ' ' + (err.message ?? '-'));
    handler.next(err);
  }
}