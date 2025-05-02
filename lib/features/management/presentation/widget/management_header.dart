import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/features/country/presentation/country_list_provider.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/widgets/custom_drop_down_button.dart';
import 'package:ip_manager/widgets/search_text_field.dart';

class ManagementHeader extends ConsumerStatefulWidget {
  const ManagementHeader({super.key});

  @override
  ConsumerState<ManagementHeader> createState() => _ManagementHeaderState();
}

class _ManagementHeaderState extends ConsumerState<ManagementHeader> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final countryList = ref.watch(countryListProvider);

    return Padding(
      padding: AppTheme.hPadding16,
      child: Row(
        children: [
          // 1) 검색창
          Expanded(
            flex: 3,
            child: SearchTextField(
              hintText: 'PC방 이름으로 검색',
              controller: _controller,
              onChanged: (text) {
                // 입력이 바뀔 때마다 바로 필터
                ref
                    .read(managementViewModelProvider.notifier)
                    .searchStoreName(name: text.trim());
              },
              onComplete: () {
                // 키보드 엔터 눌렀을 때도 동일 동작 (선택사항)
                ref
                    .read(managementViewModelProvider.notifier)
                    .searchStoreName(name: _controller.text.trim());
              },
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            flex: 1,
            child: CustomDropDownButton(
                countryList: countryList,
                onChanged: (newCountry) {
                  ref
                      .read(managementViewModelProvider.notifier)
                      .getCountryStoreList(countryId: newCountry.pId);
                }),
          ),
        ],
      ),
    );
  }
}
