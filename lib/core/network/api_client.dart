import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ip_manager/core/network/api_endpoints.dart';
import 'package:ip_manager/core/network/api_interceptors.dart';
import 'package:ip_manager/core/network/remote_data_source.dart';
import 'package:riverpod/riverpod.dart';

/// **API 클라이언트 Provider**
final apiClientProvider = Provider<ApiClient>((ref) {
  final interceptor = ref.read(apiInterceptorProvider);
  return ApiClient(interceptor);
});

enum DioMethod { post, put, get, delete }

class ApiClient implements RemoteDataSource {
  late final Dio _dio;

  ApiClient(ApiInterceptors interceptor) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints().baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {"Content-Type": "application/json"},
      ),
    );
    _dio.interceptors.add(interceptor);
  }

  @override
  Future<Response> request(
    DioMethod dioMethod, {
    required String url,
    Map<String, dynamic>? data,
  }) async {
    late Response? res;

    try {
      switch (dioMethod) {
        case DioMethod.post:
          res = await dioPost(url, data: data);
          break;
        case DioMethod.get:
          res = await dioGet(url, queryData: data);
          break;
        case DioMethod.put:
          res = await dioPut(url, data: data);
          break;
        case DioMethod.delete:
          res = await dioDelete(url, data: data);
          break;
      }
      return res;
    } catch (error) {
      rethrow;
    }
  }

  // void setAuthorizationToken(String token) {
  //   _accessToken = token;
  //   _dio.options.headers["Authorization"] = "Bearer $_accessToken";
  //   debugPrint(" Authorization Token Set: Bearer $_accessToken");
  // }

  Future<Response> dioPost(String url, {required dynamic data}) async {
    debugPrint("[Flutter] >> Dio Post \nUrl : $url, Data:$data");
    Response response = await _dio.post(url, data: data);
    return response;
  }

  Future<Response> dioGet(String url, {dynamic queryData}) async {
    debugPrint("[Flutter] >> Dio Get \nUrl : $url, Data:$queryData");
    Response response;
    if (queryData == null) {
      response = await _dio.get(url);
    } else {
      response = await _dio.get(url, queryParameters: queryData);
    }
    return response;
  }

  Future<Response> dioPut(String url, {required dynamic data}) async {
    debugPrint("[Flutter] >> Dio Put\nUrl : $url, Data:$data");
    Response response = await _dio.put(url, data: data);
    return response;
  }

  Future<Response> dioDelete(String url, {dynamic data}) async {
    debugPrint("[Flutter] >> Dio Delete\nUrl : $url, Data:$data");
    Response response;
    if (data == null) {
      response = await _dio.delete(url);
    } else {
      response = await _dio.delete(url, data: data);
    }
    return response;
  }
}
