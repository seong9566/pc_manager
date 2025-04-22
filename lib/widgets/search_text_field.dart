// lib/widgets/search_text_field.dart

import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/app_colors.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onComplete;

  const SearchTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: onComplete,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),

        // 검색 아이콘을 왼쪽에 배치
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Icon(Icons.search, color: Colors.grey),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 40, minHeight: 40),

        // 내부 여백
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),

        // 배경 채우기
        filled: true,
        fillColor: Colors.white,

        // 모서리 둥글게, 테두리 색상 동일
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.purpleColor),
        ),

        isDense: true,
      ),
    );
  }
}
