import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/database/prefs.dart';

final apiInterceptorProvider = Provider<ApiInterceptors>((ref) {
  return ApiInterceptors();
});

/// **API 요청/응답 Interceptor**
class ApiInterceptors extends InterceptorsWrapper {
  String? _accessToken;

  /// **Interceptor 생성자**
  ApiInterceptors();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 토큰이 없으면 Prefs에서 가져오기
    _accessToken ??= await Prefs().getToken;
    options.headers.addAll({"Authorization": "Bearer $_accessToken"});
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("[Dio] Response: ${response.statusCode}");
    return handler.next(response);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    debugPrint("[Dio] Error: ${e.message}");
    return handler.next(e);
  }

  /// **토큰 설정 함수**
  void setAuthorizationToken(String token) {
    _accessToken = token;
    debugPrint("Authorization Token Set: Bearer $_accessToken");
  }
}
