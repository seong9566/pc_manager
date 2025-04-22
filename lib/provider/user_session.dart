import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 세션에 담길 데이터
class UserSession {
  final String? role;
  final bool? isLogin; // ← 토큰 필드 추가

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
  UserSessionNotifier() : super(const UserSession());

  /// 로그인 시 토큰·역할 세팅
  void updateSession({
    required String role,
    required bool isLogin,
  }) {
    state = state.copyWith(role: role, isLogin: isLogin);
    debugPrint(
        "[Flutter] >> updateSession : role=${state.role}, token=${state.isLogin}");
  }

  /// 로그아웃 시 세션 초기화
  void clearSession() {
    state = const UserSession();
    debugPrint("[Flutter] >> clearSession");
  }
}

/// 전역 프로바이더
final userSessionProvider =
    StateNotifierProvider<UserSessionNotifier, UserSession>(
  (ref) => UserSessionNotifier(),
);
