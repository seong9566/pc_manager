import 'package:flutter/material.dart';

import '../core/config/app_colors.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const DefaultButton({super.key, required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.purpleColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: callback,
        // hover 시 배경색 변경 (웹/데스크탑)
        hoverColor: AppColors.purpleColor.withOpacity(0.8),
        // ripple splash
        splashColor: Colors.white24,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
