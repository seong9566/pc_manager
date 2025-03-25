import 'package:ip_manager/model/login_model.dart';
import 'package:riverpod/riverpod.dart';

import '../data/auth_repository.dart';

/**
 *  비즈니스 로직을 처리하는 계층
 *  여러개의 Repository를 조합해야한다면, UseCase에서 처리 하기
 */
final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  return AuthUseCase(ref.read(authRepositoryProvider));
});

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase(this.authRepository);

  Future<LoginModel> login(String loginId, String loginPw) async {
    return await authRepository.login(loginId, loginPw);
  }

  Future<SignModel> sign(String userId, String passWord) async {
    return await authRepository.sign(userId, passWord);
  }
}
