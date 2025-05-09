import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/database/prefs.dart';

import '../domain/login_use_case.dart';

final loginViewModelProvider = AsyncNotifierProvider<LoginViewModel, bool>(
  () => LoginViewModel(),
);

class LoginViewModel extends AsyncNotifier<bool> {
  late final AuthUseCase _loginUseCase;

  /// 초기 상태
  @override
  FutureOr<bool> build() {
    _loginUseCase = ref.read(authUseCaseProvider);
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
      await getRole();
      state = AsyncValue.data(true);
    } catch (e, stackTrace) {
      final errorMessage = e.toString().split(': ').last;
      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }

  Future<void> getRole() async {
    try {
      final user = await _loginUseCase.getRole();
      debugPrint("[Flutter] >> user : ${user.role}");
      String role = user.role;
      Prefs().setUserRole(role);
    } catch (e) {
      debugPrint("[Flutter] >> ViewModel GetRole $e");
    }
  }

  Future<void> sign(String userId, String passWord) async {
    state = const AsyncValue.loading();
    try {
      final user = await _loginUseCase.sign(userId, passWord);
      if (user.code != 200) {
        throw Exception('${user.code} : 일시적인 오류 발생 다시 시도 해주세요.');
      }
      if (user.success == false) {
        throw Exception('${user.message}');
      }

      // if (user.data == null) {
      //   throw Exception('${user.message}');
      // }
      state = AsyncValue.data(true);
    } catch (e, stackTrace) {
      final errorMessage = e.toString().split(': ').last;
      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }
}
