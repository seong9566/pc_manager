import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ip_manager/features/auth/presentation/login_view.dart';
import 'package:ip_manager/features/base/presentation/base_view.dart';
import 'package:ip_manager/provider/user_session.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    // Riverpod 컨테이너에서 세션 읽기
    final container = ProviderScope.containerOf(context, listen: false);
    final session = container.read(userSessionProvider);
    final loggedIn = session.role != null && session.role!.isNotEmpty;

    // 로그인 화면(/)으로 가는 중인지 여부
    final goingToLogin = state.uri.toString() == '/';

    if (!loggedIn && !goingToLogin) {
      // 인증 안 된 상태에서 / 이외 경로 접근 시 → 로그인으로
      return '/';
    }
    if (loggedIn && goingToLogin) {
      // 인증 된 상태에서 / 접근 시 → /base 로
      return '/base';
    }
    return null; // 그 외에는 원래 요청대로 진행
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (_, __) => const LoginView(),
    ),
    GoRoute(
      path: '/base',
      name: 'base',
      pageBuilder: (_, __) => NoTransitionPage(child: BaseView()),
    ),
  ],
);
