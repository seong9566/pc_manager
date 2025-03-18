import 'package:dio/dio.dart';
import 'package:ip_manager/core/network/api_client.dart';

abstract class RemoteDataSource {
  Future<Response> request(
    DioMethod dioMethod, {
    required String url,
    Map<String, dynamic>? data,
  });
}
