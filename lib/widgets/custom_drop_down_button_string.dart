import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ip_manager/core/config/screen_size.dart';

/// 문자열 리스트를 사용하는 드롭다운 버튼 위젯
class CustomDropDownButtonString extends StatefulWidget {
  final List<String> cityList;
  final Function(String selectedCity) onChanged;
  final String? hintText;
  final String? selectedValue; // 추가: 외부에서 선택값을 제어할 수 있는 속성

  const CustomDropDownButtonString({
    super.key,
    required this.cityList,
    required this.onChanged,
    this.hintText,
    this.selectedValue, // 추가: 초기화 기능을 위한 선택값
  });

  @override
  State<CustomDropDownButtonString> createState() =>
      _CustomDropDownButtonStringState();
}

class _CustomDropDownButtonStringState
    extends State<CustomDropDownButtonString> {
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedValue;
  }

  @override
  void didUpdateWidget(CustomDropDownButtonString oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부에서 선택값이 변경되면 업데이트 (초기화 기능 지원)
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        _selectedCity = widget.selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 디바이스 크기 분류
    final isSmallScreen = Responsive.isMobile(context); // 모바일 폰
    final isTablet = Responsive.isTablet(context); // 태블릿

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: false,
        hint: Text(
          widget.hintText ?? '도시',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize:
                isSmallScreen ? 12 : (isTablet ? 13 : 14), // 태블릿에 적합한 글자 크기
            color: Colors.grey.shade600,
          ),
        ),
        value: _selectedCity,
        items: widget.cityList.map((city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(
              city,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontSize: isSmallScreen
                      ? 12
                      : (isTablet ? 13 : 14)), // 태블릿에 적합한 글자 크기
            ),
          );
        }).toList(),
        onChanged: (selectedCity) {
          setState(() => _selectedCity = selectedCity);
          if (selectedCity != null) {
            widget.onChanged(selectedCity);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: isSmallScreen ? 48 : (isTablet ? 48 : 48), // 태블릿에서는 중간 크기
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 5 : (isTablet ? 6 : 8)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.zero,
          offset: const Offset(0, -3), // 태블릿에 더 적합한 오프셋
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 4.0 : (isTablet ? 8.0 : 6.0)),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.focused)
                ? Colors.grey.shade100
                : null,
          ),
        ),
      ),
    );
  }
}
