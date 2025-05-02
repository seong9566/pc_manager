import 'package:flutter/material.dart';

import '../core/config/app_colors.dart';

class SimpleButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const SimpleButton({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: AppColors.purpleColor, // 테두리 선명 보라
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.purpleColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      onEnter: (_) {},
    );
  }
}
