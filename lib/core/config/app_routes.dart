import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:ip_manager/features/auth/presentation/login_view.dart';
import 'package:ip_manager/features/auth/presentation/signup_view.dart';
import 'package:ip_manager/features/base/presentation/base_view.dart';
import 'package:ip_manager/provider/user_session.dart';
import 'package:ip_manager/core/utils/cache_manager.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    // 웹 플랫폼에서만 캐시 유효성 검사 수행
    // 캐시 무효화 시 userSessionProvider 초기화를 위한 콜백 함수 전달
    CacheManager.checkCacheValidity(onCacheInvalidated: () {
      // Riverpod 컨테이너에서 세션 초기화
      final container = ProviderScope.containerOf(context, listen: false);
      final sessionNotifier = container.read(userSessionProvider.notifier);
      sessionNotifier.clearSession();
      debugPrint("[Flutter] >> 캐시 무효화로 인한 세션 초기화 완료");
    });

    // Riverpod 컨테이너에서 세션 읽기
    final container = ProviderScope.containerOf(context, listen: false);
    final session = container.read(userSessionProvider);
    debugPrint("[Flutter] >> 세션 읽기: ${session.role}, ${session.isLogin}");
    final loggedIn = session.role != null && session.role!.isNotEmpty;

    // 로그인 화면(/) 또는 회원가입 화면(/signup)으로 가는 중인지 여부
    final goingToAuthPage = state.uri.toString() == '/' || state.uri.toString() == '/signup';

    print("[Flutter] >> 로그인 상태: $loggedIn, 인증 페이지로 가는 중: $goingToAuthPage");
    if (!loggedIn && !goingToAuthPage) {
      // 인증 안 된 상태에서 인증 페이지 이외 경로 접근 시 → 로그인으로
      return '/';
    }
    if (loggedIn && state.uri.toString() == '/') {
      // 인증 된 상태에서 로그인 페이지 접근 시 → /base 로
      return '/base';
    }
    return null; // 그 외에는 원래 요청대로 진행
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      parentNavigatorKey: _rootNavigatorKey,
      // builder: (_, __) => const LoginView(),
      pageBuilder: (_, __) => NoTransitionPage(child: LoginView()),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (_, __) => NoTransitionPage(child: SignUpView()),
    ),
    GoRoute(
      path: '/base',
      name: 'base',
      pageBuilder: (_, __) => NoTransitionPage(child: BaseView()),
    ),
  ],
);
