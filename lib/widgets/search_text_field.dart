import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function onComplete;

  const SearchTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        controller: controller,
        onEditingComplete: () {
          onComplete();
        },
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 28),
            child: Icon(Icons.search),
          ),
          contentPadding: EdgeInsets.only(left: 28, top: 15, bottom: 15),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
