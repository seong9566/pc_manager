import 'package:ip_manager/model/login_model.dart';
import 'package:riverpod/riverpod.dart';

import 'login_service.dart';

final signRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(loginServiceProvider));
});

/**
 * LoginService에서 데이터를 가져와 LoginModel로 변환
 * UI 계층이 API 응답 데이터에 의존되지 않도록 해줌.
 */
class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  /// ** Login **
  Future<LoginModel> login(String loginId, String loginPw) async {
    final responseData = await authService.login(loginId, loginPw);

    return LoginModel.fromJson(responseData.data);
  }

  /// ** Sign **
  Future<SignModel> sign(String userId, String passWord) async {
    final responseData = await authService.sign(userId, passWord);

    return SignModel.fromJson(responseData.data);
  }

  // /// **로그아웃 API 호출**
  // Future<void> logout() async {
  //   await apiClient.request(DioMethod.post, url: "/auth/logout");
  // }
}
