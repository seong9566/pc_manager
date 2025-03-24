import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/app_routes.dart';
import 'package:ip_manager/core/config/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
