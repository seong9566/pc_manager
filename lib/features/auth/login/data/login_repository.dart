import 'package:ip_manager/core/network/api_client.dart';
import 'package:ip_manager/core/network/api_endpoints.dart';
import 'package:ip_manager/core/network/remote_data_source.dart';
import 'package:ip_manager/model/login_model.dart';
import 'package:ip_manager/features/auth/login/data/login_service.dart';
import 'package:riverpod/riverpod.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(ref.read(loginServiceProvider));
});

/**
 * LoginService에서 데이터를 가져와 LoginModel로 변환
 * UI 계층이 API 응답 데이터에 의존되지 않도록 해줌.
 */
class LoginRepository {
  final LoginService loginService;

  LoginRepository(this.loginService);

  /// ** Login **
  Future<LoginModel> login(String loginId, String loginPw) async {
    final responseData = await loginService.login(loginId, loginPw);

    return LoginModel.fromJson(responseData.data);
  }

  // /// **로그아웃 API 호출**
  // Future<void> logout() async {
  //   await apiClient.request(DioMethod.post, url: "/auth/logout");
  // }
}
