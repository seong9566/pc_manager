import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../core/config/app_theme.dart';

/// 문자열 리스트를 사용하는 드롭다운 버튼 위젯
class CustomDropDownButtonString extends StatefulWidget {
  final List<String> cityList;
  final Function(String selectedCity) onChanged;

  const CustomDropDownButtonString({
    super.key, 
    required this.cityList, 
    required this.onChanged
  });

  @override
  State<CustomDropDownButtonString> createState() => _CustomDropDownButtonStringState();
}

class _CustomDropDownButtonStringState extends State<CustomDropDownButtonString> {
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          '도시',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        value: _selectedCity,
        items: widget.cityList.map((city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(city),
          );
        }).toList(),
        onChanged: (selectedCity) {
          setState(() => _selectedCity = selectedCity);
          if (selectedCity != null) {
            widget.onChanged(selectedCity);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 46,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: AppTheme.mainBorder,
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
