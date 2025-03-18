import 'package:dio/dio.dart';
import 'package:ip_manager/core/network/api_client.dart';
import 'package:ip_manager/core/network/api_endpoints.dart';
import 'package:riverpod/riverpod.dart';

final loginServiceProvider = Provider<LoginService>((ref) {
  return LoginService(ref.read(apiClientProvider));
});

/**
 * 1. ApiClient를 호출
 * 2. API 요청을 수행하는 Data Layer
 * 3. API 요청 후 가공되지 않은 원본 데이터를 Response
 */
class LoginService {
  final ApiClient apiClient;

  LoginService(this.apiClient);

  /// ** Login **
  Future<Response> login(String loginId, String loginPw) async {
    final response = await apiClient.request(
      DioMethod.post,
      url: ApiEndPoints.login,
      data: {"loginId": loginId, "loginPw": loginPw},
    );
    return response; // 원본 API 응답 데이터 반환
  }

  /// ** Logout **
  // Future<void> logout() async {
  //   await apiClient.request(
  //     DioMethod.post,
  //     url: ApiEndPoints.lo,
  //   );
  // }
}
