import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ip_manager/core/config/app_routes.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate, // ← 위젯 로케일
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate, // ← Syncfusion 달력 한글 지원
      ],
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
        // 필요에 따라 다른 로케일 추가
      ],
    );
  }
}
