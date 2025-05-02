import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/country/presentation/country_list_provider.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/widgets/search_text_field.dart';

import '../../../../model/country_info_model.dart';

class ManagementHeader extends ConsumerStatefulWidget {
  const ManagementHeader({super.key});

  @override
  ConsumerState<ManagementHeader> createState() => _ManagementHeaderState();
}

class _ManagementHeaderState extends ConsumerState<ManagementHeader> {
  final TextEditingController _controller = TextEditingController();
  CountryInfoModel? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final countryList = ref.watch(countryListProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          // 1) 검색창
          Expanded(
            flex: 3,
            child: SearchTextField(
              hintText: 'PC방 이름으로 검색',
              controller: _controller,
              onComplete: () {
                ref
                    .read(managementViewModelProvider.notifier)
                    .getStoreList(pcName: _controller.text.trim());
              },
            ),
          ),
          const SizedBox(width: 16),

          // 2) 국가 드롭다운
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
                  if (newCountry != null) {
                    ref
                        .read(managementViewModelProvider.notifier)
                        .getCountryStoreList(countryId: newCountry.pId);
                  }
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
          ),
        ],
      ),
    );
  }
}
