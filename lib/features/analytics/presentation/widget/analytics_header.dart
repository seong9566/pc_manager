// lib/features/analytics/presentation/widget/analytics_header.dart

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/country_info_model.dart';
import '../../../../widgets/search_text_field.dart';
import '../../../country/presentation/country_list_provider.dart';

class AnalyticsHeader extends ConsumerStatefulWidget {
  final void Function(String pcName) onSearch;
  final void Function(int countryTbId) onCountryChanged;

  const AnalyticsHeader({
    super.key,
    required this.onSearch,
    required this.onCountryChanged,
  });

  @override
  ConsumerState<AnalyticsHeader> createState() => _AnalyticsHeaderState();
}

class _AnalyticsHeaderState extends ConsumerState<AnalyticsHeader> {
  final TextEditingController _controller = TextEditingController();
  CountryInfoModel? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final countryList = ref.watch(countryListProvider);

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

          Expanded(
            flex: 1,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<CountryInfoModel>(
                isExpanded: true,
                hint: Text(
                  '도시',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                value: _selectedCountry,
                items: countryList.map((c) {
                  return DropdownMenuItem<CountryInfoModel>(
                    value: c,
                    child: Text(c.countryName),
                  );
                }).toList(),
                onChanged: (newCountry) {
                  setState(() => _selectedCountry = newCountry);

                  /// 탭 별로 도시 이름을 파라미터로 던져서 API 요청
                  widget.onCountryChanged(_selectedCountry!.pId);
                },
                buttonStyleData: ButtonStyleData(
                  height: 40,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
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
            ),
          )
        ],
      ),
    );
  }
}
