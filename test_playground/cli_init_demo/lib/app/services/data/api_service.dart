import 'package:dio/dio.dart';
import '../../config/network/dio_client.dart';
import '../../config/network/api_constants.dart';

class ApiService {
  final DioClient _client = DioClient.getInstance();

  Future<Response> fetchUsers() {
    return _client.dio.get('https://jsonplaceholder.typicode.com/users');
  }
}
