import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/database/prefs.dart';

/// 세션에 담길 데이터
class UserSession {
  final String? role;
  final bool? isLogin;

  const UserSession({this.role, this.isLogin});

  UserSession copyWith({
    String? role,
    bool? isLogin,
  }) {
    return UserSession(
      role: role ?? this.role,
      isLogin: isLogin ?? this.isLogin,
    );
  }
}

/// 세션 상태를 관리하는 Notifier
class UserSessionNotifier extends StateNotifier<UserSession> {
// 싱글톤으로 관리
  static final UserSessionNotifier _instance = UserSessionNotifier._internal();
  factory UserSessionNotifier() => _instance;
  UserSessionNotifier._internal() : super(const UserSession());

  /// 로그인 시 토큰·역할 세팅
  void updateSession({
    required String role,
    required bool isLogin,
  }) {
    state = state.copyWith(role: role, isLogin: isLogin);
    debugPrint(
        "[Flutter] >> updateSession : role=${state.role}, token=${state.isLogin}");
  }

  /// 로그아웃 시 세션 초기화 및 SharedPreferences 데이터 삭제
  Future<void> clearSession() async {
    // 세션 상태 초기화
    state = state.copyWith(role: null, isLogin: false);

    // SharedPreferences 데이터 삭제
    await Prefs().clear();

    debugPrint("[Flutter] >> clearSession 완료 (세션 및 SharedPreferences 초기화)");
  }
}

/// 전역 프로바이더
final userSessionProvider =
    StateNotifierProvider<UserSessionNotifier, UserSession>(
  (ref) => UserSessionNotifier(),
);
