import 'package:ip_manager/features/auth/login/data/login_repository.dart';
import 'package:ip_manager/model/login_model.dart';
import 'package:riverpod/riverpod.dart';

/**
 *  비즈니스 로직을 처리하는 계층
 *  여러개의 Repository를 조합해야한다면, UseCase에서 처리 하기
 */
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(loginRepositoryProvider));
});

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  Future<LoginModel> login(String loginId, String loginPw) async {
    return await loginRepository.login(loginId, loginPw);
  }
}
