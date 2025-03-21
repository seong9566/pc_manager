import 'dart:async';

import 'package:ip_manager/features/auth/login/domain/login_use_case_impl.dart';
import 'package:riverpod/riverpod.dart';

final loginViewModelProvider = AsyncNotifierProvider<LoginViewModel, bool>(
  () => LoginViewModel(),
);

class LoginViewModel extends AsyncNotifier<bool> {
  late final LoginUseCase _loginUseCase;

  /// 초기 상태
  @override
  FutureOr<bool> build() {
    _loginUseCase = ref.read(loginUseCaseProvider);
    return false;
  }

  Future<void> login(String loginId, String loginPw) async {
    state = const AsyncValue.loading();
    try {
      final user = await _loginUseCase.login(loginId, loginPw);
      if (user.code != 200) {
        throw Exception('${user.code} : 일시적인 오류 발생 다시 시도 해주세요.');
      }
      if (user.data == null) {
        throw Exception('${user.message}');
      }
      state = AsyncValue.data(true);
    } catch (e, stackTrace) {
      final errorMessage = e.toString().split(': ').last;
      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }
}
