import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final bool? isSubAddress;
  final bool error;
  final String hintText;
  final TextEditingController controller;

  const AuthTextField({
    super.key,
    this.error = false,
    required this.hintText,
    required this.controller,
    this.isSubAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border:
            error
                ? Border.all(color: Colors.red)
                : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        style: TextStyle(color: error ? Colors.red : Colors.grey),
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
