import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ip_manager/features/auth/login/presentation/login_view.dart';
import 'package:ip_manager/features/base/presentation/base_view.dart';
import 'package:ip_manager/features/store_add/presentation/store_add_view.dart';
import 'package:ip_manager/features/tmp/tmp_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/base',
      name: 'base',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: BaseView());
      },
    ),

    // GoRoute(
    //   path: '/storeAdd',
    //   name: 'storeAdd',
    //   pageBuilder: (context, state) {
    //     return NoTransitionPage(child: StoreAddView());
    //   },
    // ),
    GoRoute(
      path: '/tmp',
      name: 'tmp',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: TmpView());
      },
    ),
  ],
);
