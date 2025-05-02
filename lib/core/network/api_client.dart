import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/network/api_endpoints.dart';
import 'package:ip_manager/core/network/api_interceptors.dart';
import 'package:ip_manager/core/network/remote_data_source.dart';

/// **API 클라이언트 Provider**
/// Dio 요청시 병렬 처리가 안되는 문제
/// 문제 : Dio 요청시 Options를 공유 해서이다.
/// Flutter Web 특성상 공유를 하게 되면 요청이 누락되거나, 늦어지는 경우가 종종 있다.
/// Delay를 주는 방법 + 각 요청 마다 Option을 정의 해서 요청시 공유 하지 않도록 하는게 바람직하다.
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
        /// 모든 에러 코드를 허용, 직접 컨트롤 하기 위함
        validateStatus: (status) => true,
        baseUrl: ApiEndPoints().baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),

        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
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
      return res!;
    } catch (error) {
      rethrow;
    }
  }

  // void setAuthorizationToken(String token) {
  //   _accessToken = token;
  //   _dio.options.headers["Authorization"] = "Bearer $_accessToken";
  //   debugPrint(" Authorization Token Set: Bearer $_accessToken");
  // }

  Future<Response?> dioGet(String url, {dynamic queryData}) async {
    try {
      debugPrint("[Flutter] >> Dio Get Url : $url, queryData :$queryData");
      return await _dio.get(
        url,
        queryParameters: queryData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
        ),
      );
    } on DioException catch (e) {
      throw {
        "header": e.requestOptions.headers["authorization"],
        "method": "GET",
        "statusCode": e.response?.statusCode,
        "message": e.response?.data ?? "",
        "url": url,
        "error": e.error,
      };
    }
  }

  Future<Response?> dioPost(String url, {required dynamic data}) async {
    try {
      debugPrint("[Flutter] >> Dio Post Url : $url, Data:$data");
      return await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
        ),
      );
    } on DioException catch (e) {
      throw {
        "header": e.requestOptions.headers["authorization"],
        "method": "POST",
        "statusCode": e.response?.statusCode,
        "message": e.response?.data ?? "",
        "url": url,
        "error": e.error,
      };
    }
  }

  Future<Response?> dioPut(String url, {required dynamic data}) async {
    try {
      debugPrint("[Flutter] >> Dio Put Url : $url, Data:$data");
      return await _dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
        ),
      );
    } on DioException catch (e) {
      throw {
        "header": e.requestOptions.headers["authorization"],
        "method": "PUT",
        "statusCode": e.response?.statusCode,
        "message": e.response?.data ?? "",
        "url": url,
        "error": e.error,
      };
    }
  }

  Future<Response?> dioDelete(String url, {dynamic data}) async {
    try {
      debugPrint("[Flutter] >> Dio Delete Url : $url, Data:$data");
      return await _dio.delete(
        url,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
        ),
      );
    } on DioException catch (e) {
      throw {
        "header": e.requestOptions.headers["authorization"],
        "method": "DELETE",
        "statusCode": e.response?.statusCode,
        "message": e.response?.data ?? "",
        "url": url,
        "error": e.error,
      };
    }
  }
}
