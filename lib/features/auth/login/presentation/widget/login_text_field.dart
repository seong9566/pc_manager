import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final bool? isSubAddress;
  final String hintText;
  final TextEditingController controller;

  const LoginTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isSubAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(left: 12, top: 18),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
