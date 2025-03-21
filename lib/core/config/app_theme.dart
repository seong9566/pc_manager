import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/app_colors.dart';

class AppTheme {
  // color: Colors.white,
  // borderRadius: BorderRadius.all(Radius.circular(8)),
  static BoxShadow greyShadow = BoxShadow(
    color: Colors.grey.shade400,
    offset: const Offset(0, 0),
    blurRadius: 8,
  );

  static ThemeData themeData = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppColors.backgroundColor,
  );
}
