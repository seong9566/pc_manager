import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        customButton: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('도시 별로 보기'),
            SizedBox(width: 30),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
          ],
        ),
        items: [
          _dropdownMenuItem("서울"),
          _dropdownMenuItem("부산"),
          _dropdownMenuItem("대구"),
          _dropdownMenuItem("전주"),
          _dropdownMenuItem("대전"),
        ],
        onChanged: (value) {},
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(0, 0),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _dropdownMenuItem(String label) {
    return DropdownMenuItem(
      value: label,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}
