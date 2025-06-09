import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool? isSubAddress;
  final String hintText;
  final TextEditingController controller;
  final bool? isEdit;
  final bool useExpanded;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isSubAddress = false,
    this.isEdit = false,
    this.useExpanded = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    Widget textFieldWidget = Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: isEdit!,
        style: TextStyle(
          color: isEdit! ? Colors.grey : Colors.black,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(left: 12, top: 12),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );

    // useExpanded가 true인 경우에만 Expanded로 감싸기
    return useExpanded ? Expanded(child: textFieldWidget) : textFieldWidget;
  }
}
