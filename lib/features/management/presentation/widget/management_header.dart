import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/features/region/presentation/region_info_provider.dart';
import 'package:ip_manager/widgets/custom_drop_down_button_string.dart';
import 'package:ip_manager/widgets/search_text_field.dart';

import '../../../../core/config/screen_size.dart';

class ManagementHeader extends ConsumerStatefulWidget {
  const ManagementHeader({super.key});

  @override
  ConsumerState<ManagementHeader> createState() => _ManagementHeaderState();
}

class _ManagementHeaderState extends ConsumerState<ManagementHeader> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cityList = ref.watch(cityListProvider);

    return Responsive.isDesktop(context)
        ? _desktop(cityList)
        : _mobile(cityList);
  }

  Widget _mobile(List<String> cityList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1) 검색창
        SearchTextField(
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
        const SizedBox(height: 16),

        CustomDropDownButtonString(
            cityList: cityList,
            onChanged: (selectedCity) {
              // 선택된 도시 이름으로 처리
              ref
                  .read(managementViewModelProvider.notifier)
                  .getCountryStoreList(cityName: selectedCity);
            }),
      ],
    );
  }

  Widget _desktop(List<String> cityList) {
    return Row(
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
          child: CustomDropDownButtonString(
              cityList: cityList,
              onChanged: (selectedCity) {
                ref
                    .read(managementViewModelProvider.notifier)
                    .getCountryStoreList(cityName: selectedCity);
              }),
        ),
      ],
    );
  }
}
