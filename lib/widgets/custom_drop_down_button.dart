import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../core/config/app_theme.dart';
import '../model/country_info_model.dart';

class CustomDropDownButton extends StatefulWidget {
  final List<CountryInfoModel> countryList;
  final Function(CountryInfoModel newCountry) onChanged;

  const CustomDropDownButton(
      {super.key, required this.countryList, required this.onChanged});

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  CountryInfoModel? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<CountryInfoModel>(
        isExpanded: true,
        hint: Text(
          '도시',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        value: _selectedCountry,
        items: widget.countryList.map((c) {
          return DropdownMenuItem<CountryInfoModel>(
            value: c,
            child: Text(c.countryName),
          );
        }).toList(),
        onChanged: (newCountry) {
          setState(() => _selectedCountry = newCountry);
          if (newCountry != null) {
            widget.onChanged(newCountry);
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
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey)],
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
