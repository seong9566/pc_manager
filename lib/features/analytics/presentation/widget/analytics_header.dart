// lib/features/analytics/presentation/widget/analytics_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../widgets/search_text_field.dart';

class AnalyticsHeader extends ConsumerStatefulWidget {
  final void Function(String pcName) onSearch;

  const AnalyticsHeader({Key? key, required this.onSearch}) : super(key: key);

  @override
  ConsumerState<AnalyticsHeader> createState() => _AnalyticsHeaderState();
}

class _AnalyticsHeaderState extends ConsumerState<AnalyticsHeader> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // 검색창
          Expanded(
            flex: 3,
            child: SearchTextField(
              hintText: 'PC방 이름으로 검색',
              controller: _controller,
              onComplete: () {
                widget.onSearch(_controller.text.trim());
                _controller.clear();
              },
            ),
          ),

          const SizedBox(width: 16),

          // 도시 선택 드롭다운 (미구현 필터 콜백 자리)
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  '도시 별로 보기',
                  style: TextStyle(color: Colors.grey),
                ),
                value: _selectedCity,
                items: <String>[
                  '전체',
                  '서울',
                  '부산',
                  '대구',
                  '전주',
                  '대전',
                ].map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(
                      city,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCity = value);
                  // TODO: 도시별 필터 로직
                },

                // 버튼 스타일
                buttonStyleData: ButtonStyleData(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                  ),
                  elevation: 0,
                ),

                // 아이콘 스타일
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                ),

                // 드롭다운 박스 스타일
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  elevation: 4,
                ),

                // 메뉴 아이템 스타일
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
