import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ip_manager/features/auth/login/presentation/login_screen.dart';
import 'package:ip_manager/features/base/base_view.dart';
import 'package:ip_manager/features/tmp/tmp_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: BaseView());
      },
    ),
    GoRoute(
      path: '/tmp',
      name: 'tmp',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: TmpView());
      },
    ),
  ],
);
