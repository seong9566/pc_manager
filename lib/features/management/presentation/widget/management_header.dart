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
    // 국가 목록 가져오기
    final countryList = ref.watch(countryNameListProvider);
    // 선택된 국가에 따른 도시 목록 가져오기
    final cityList = ref.watch(cityNamesByCountryProvider);
    // 선택된 국가와 도시에 따른 동네 목록 가져오기
    final townList = ref.watch(townNamesByCountryCityProvider);

    return Responsive.isDesktop(context)
        ? _desktop(countryList, cityList, townList)
        : _mobile(countryList, cityList, townList);
  }

  Widget _mobile(
      List<String> countryList, List<String> cityList, List<String> townList) {
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

        // 드롭다운 버튼들을 가로로 배치
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 국가(지역) 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: countryList,
                hintText: '지역',
                selectedValue: ref.watch(selectedCountryProvider),
                onChanged: (selectedCountry) {
                  // 선택된 국가 이름 저장
                  ref.read(selectedCountryProvider.notifier).state =
                      selectedCountry;
                  // 선택된 도시 초기화
                  ref.read(selectedCityProvider.notifier).state = null;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

                  // 선택된 국가로 필터링
                  ref
                      .read(managementViewModelProvider.notifier)
                      .filterStoresByLocation(countryName: selectedCountry);
                },
              ),
            ),
            SizedBox(width: 8),
            // 도시 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: cityList,
                hintText: '도시',
                selectedValue: ref.watch(selectedCityProvider),
                onChanged: (selectedCity) {
                  // 선택된 도시 이름 저장
                  ref.read(selectedCityProvider.notifier).state = selectedCity;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

                  // 선택된 국가와 도시로 필터링
                  final selectedCountry = ref.read(selectedCountryProvider);
                  ref
                      .read(managementViewModelProvider.notifier)
                      .filterStoresByLocation(
                        countryName: selectedCountry,
                        cityName: selectedCity,
                      );
                },
              ),
            ),
            SizedBox(width: 8),
            // 동네 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: townList,
                hintText: '동네',
                selectedValue: ref.watch(selectedTownProvider),
                onChanged: (selectedTown) {
                  // 선택된 동네 이름 저장
                  ref.read(selectedTownProvider.notifier).state = selectedTown;

                  // 선택된 국가, 도시, 동네로 필터링
                  final selectedCountry = ref.read(selectedCountryProvider);
                  final selectedCity = ref.read(selectedCityProvider);
                  ref
                      .read(managementViewModelProvider.notifier)
                      .filterStoresByLocation(
                        countryName: selectedCountry,
                        cityName: selectedCity,
                        townName: selectedTown,
                      );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _desktop(
      List<String> countryList, List<String> cityList, List<String> townList) {
    return Column(
      children: [
        // 첫 번째 행: 검색창
        Row(
          children: [
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
            SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                final viewModel =
                    ref.read(managementViewModelProvider.notifier);
                viewModel.resetFilters();
                _controller.clear();
                ref.read(selectedCountryProvider.notifier).state = null;
                ref.read(selectedCityProvider.notifier).state = null;
                ref.read(selectedTownProvider.notifier).state = null;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side:
                    BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                minimumSize: const Size(120, 56), // 검색창과 동일한 높이 설정
                maximumSize: const Size(180, 56),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text(
                '필터 초기화',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),

        // 두 번째 행: 드롭다운 버튼들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 국가(지역) 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: countryList,
                hintText: '지역을 선택해 주세요.',
                selectedValue: ref.watch(selectedCountryProvider),
                onChanged: (selectedCountry) {
                  // 선택된 국가 이름 저장
                  ref.read(selectedCountryProvider.notifier).state =
                      selectedCountry;
                  // 선택된 도시 초기화
                  ref.read(selectedCityProvider.notifier).state = null;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

                  // 선택된 국가로 필터링
                  ref
                      .read(managementViewModelProvider.notifier)
                      .filterStoresByLocation(countryName: selectedCountry);
                },
              ),
            ),
            const SizedBox(width: 16),

            // 도시 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: cityList,
                hintText: '도시를 선택해 주세요.',
                selectedValue: ref.watch(selectedCityProvider),
                onChanged: (selectedCity) {
                  // 선택된 도시 이름 저장
                  ref.read(selectedCityProvider.notifier).state = selectedCity;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

                  // 선택된 국가와 도시로 필터링
                  final selectedCountry = ref.read(selectedCountryProvider);
                  ref
                      .read(managementViewModelProvider.notifier)
                      .filterStoresByLocation(
                        countryName: selectedCountry,
                        cityName: selectedCity,
                      );
                },
              ),
            ),
            const SizedBox(width: 16),

            // 동네 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: townList,
                hintText: '동네를 선택해 주세요.',
                selectedValue: ref.watch(selectedTownProvider),
                onChanged: (selectedTown) {
                  // 선택된 동네 이름 저장
                  ref.read(selectedTownProvider.notifier).state = selectedTown;

                  // 선택된 국가, 도시, 동네로 필터링
                  final selectedCountry = ref.read(selectedCountryProvider);
                  final selectedCity = ref.read(selectedCityProvider);
                  ref
                      .read(managementViewModelProvider.notifier)
                      .filterStoresByLocation(
                        countryName: selectedCountry,
                        cityName: selectedCity,
                        townName: selectedTown,
                      );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
