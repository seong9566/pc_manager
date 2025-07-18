import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/screen_size.dart';

class HoverButton extends StatelessWidget {
  final String text;

  final Color color;

  final IconData icon;

  final VoidCallback onTap;

  const HoverButton({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
      style: ButtonStyle(
        // 텍스트 크기
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: Responsive.isMobile(context) ? 14 : 16)),

        // 테두리 색
        side: WidgetStateProperty.all(BorderSide(color: color, width: 2)),
        // 호버됐을 때 배경 채우기
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.hovered) ? color : null,
        ),
        // 평소에는 color, 호버 시에는 흰색
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) =>
              states.contains(WidgetState.hovered) ? Colors.white : color,
        ),
        // 클릭/포커스 오버레이 컬러
        overlayColor: WidgetStateProperty.all(color.withValues(alpha: 0.2)),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
              horizontal: 16, vertical: Responsive.isMobile(context) ? 12 : 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevation: WidgetStateProperty.resolveWith<double>(
          (states) => states.contains(WidgetState.hovered) ? 2 : 0,
        ),
      ),
    );
  }
}
