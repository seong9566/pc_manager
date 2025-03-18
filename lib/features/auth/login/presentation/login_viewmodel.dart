import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ip_manager/features/auth/login/domain/login_use_case_impl.dart';
import 'package:ip_manager/model/login_model.dart';
import 'package:riverpod/riverpod.dart';

final loginViewModelProvider =
    AsyncNotifierProvider<LoginViewModel, LoginModel?>(() => LoginViewModel());

class LoginViewModel extends AsyncNotifier<LoginModel?> {
  late final LoginUseCase _loginUseCase;

  /// 초기 상태
  @override
  FutureOr<LoginModel?> build() {
    _loginUseCase = ref.read(loginUseCaseProvider);
    return null;
  }

  Future<void> login(String loginId, String loginPw) async {
    state = const AsyncValue.loading();

    try {
      final user = await _loginUseCase.login(loginId, loginPw);
      debugPrint("[Flutter] >> user : $user");
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
