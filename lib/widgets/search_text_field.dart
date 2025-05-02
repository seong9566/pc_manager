// lib/widgets/search_text_field.dart

import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/app_colors.dart';

import '../core/config/app_theme.dart';

class SearchTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onComplete;
  final ValueChanged<String>? onChanged;

  const SearchTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onComplete,
    this.onChanged,
  }) : super(key: key);

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        // 포커스 여부 바뀔 때마다 rebuild
        setState(() {});
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onComplete,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),

        // 검색 아이콘을 왼쪽에 배치, 포커스 시 보라색으로 변경
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Icon(
            size: 24,
            Icons.search,
            color: isFocused ? AppColors.purpleColor : Colors.grey,
          ),
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
          borderRadius: AppTheme.mainBorder,
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.mainBorder,
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTheme.mainBorder,
          borderSide: BorderSide(color: AppColors.purpleColor),
        ),

        isDense: true,
      ),
    );
  }
}
