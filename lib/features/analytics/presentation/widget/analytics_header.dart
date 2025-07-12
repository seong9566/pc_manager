// lib/features/analytics/presentation/widget/analytics_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/analytics/presentation/providers/analytics_filter_providers.dart';
import 'package:ip_manager/features/region/presentation/region_info_provider.dart';
import 'package:ip_manager/widgets/custom_drop_down_button_string.dart';
import 'package:ip_manager/widgets/search_text_field.dart';

class AnalyticsHeader extends ConsumerStatefulWidget {
  final void Function(String pcName) onSearch;
  final void Function({String? countryName, String? cityName, String? townName})
      onLocationChanged;

  const AnalyticsHeader({
    super.key,
    required this.onSearch,
    required this.onLocationChanged,
  });

  @override
  ConsumerState<AnalyticsHeader> createState() => _AnalyticsHeaderState();
}

class _AnalyticsHeaderState extends ConsumerState<AnalyticsHeader> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 국가 목록은 공통으로 사용 (모든 국가 목록)
    final countryList = ref.watch(countryNameListProvider);
    // 분석 화면 전용 도시 목록 (선택된 국가에 따라 필터링)
    final cityList = ref.watch(analyticsCityNamesByCountryProvider);
    // 분석 화면 전용 동네 목록 (선택된 도시에 따라 필터링)
    final townList = ref.watch(analyticsTownNamesByCountryCityProvider);

    return Responsive.isDesktop(context)
        ? _desktop(countryList, cityList, townList)
        : _mobile(countryList, cityList, townList);
  }

  Widget _mobile(
      List<String> countryList, List<String> cityList, List<String> townList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 검색창
        SearchTextField(
          hintText: 'PC방 이름으로 검색',
          controller: _controller,
          onChanged: (text) => widget.onSearch(text.trim()),
          onComplete: () => widget.onSearch(_controller.text.trim()),
        ),
        const SizedBox(height: 16),

        // 드롭다운 버튼들을 가로로 배치
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 국가(지역) 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: countryList,
                hintText: '지역',
                key: ValueKey('country_${countryList.length}'),
                onChanged: (selectedCountry) {
                  // 선택된 국가 이름 저장 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedCountryProvider.notifier).state =
                      selectedCountry;
                  // 선택된 도시 초기화 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedCityProvider.notifier).state = null;
                  // 선택된 동네 초기화 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedTownProvider.notifier).state = null;

                  // 필터링 정보 전달
                  _updateFilters();
                },
              ),
            ),
            SizedBox(width: 8),

            // 도시 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: cityList,
                hintText: '도시',
                key: ValueKey(
                    'city_${ref.read(analyticsSelectedCountryProvider) ?? ""}_${cityList.length}'),
                onChanged: (selectedCity) {
                  // 선택된 도시 이름 저장 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedCityProvider.notifier).state =
                      selectedCity;
                  // 선택된 동네 초기화 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedTownProvider.notifier).state = null;

                  // 필터링 정보 전달
                  _updateFilters();
                },
              ),
            ),
            SizedBox(width: 8),

            // 동네 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: townList,
                hintText: '동네',
                key: ValueKey('town_${ref.read(analyticsSelectedCountryProvider) ?? ""}_${ref.read(analyticsSelectedCityProvider) ?? ""}_${townList.length}'),
                onChanged: (selectedTown) {
                  // 선택된 동네 이름 저장 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedTownProvider.notifier).state =
                      selectedTown;

                  // 필터링 정보 전달
                  _updateFilters();
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
                onChanged: (text) => widget.onSearch(text.trim()),
                onComplete: () => widget.onSearch(_controller.text.trim()),
              ),
            ),
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
                key: ValueKey('country_${countryList.length}'),
                onChanged: (selectedCountry) {
                  // 선택된 국가 이름 저장 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedCountryProvider.notifier).state =
                      selectedCountry;
                  // 선택된 도시 초기화 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedCityProvider.notifier).state = null;
                  // 선택된 동네 초기화 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedTownProvider.notifier).state = null;

                  // 필터링 정보 전달
                  _updateFilters();
                },
              ),
            ),
            const SizedBox(width: 16),

            // 도시 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: cityList,
                hintText: '도시를 선택해 주세요.',
                key: ValueKey(
                    'city_${ref.read(analyticsSelectedCountryProvider) ?? ""}_${cityList.length}'),
                onChanged: (selectedCity) {
                  // 선택된 도시 이름 저장 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedCityProvider.notifier).state =
                      selectedCity;
                  // 선택된 동네 초기화 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedTownProvider.notifier).state = null;

                  // 필터링 정보 전달
                  _updateFilters();
                },
              ),
            ),
            const SizedBox(width: 16),

            // 동네 드롭다운
            Expanded(
              child: CustomDropDownButtonString(
                cityList: townList,
                hintText: '동네를 선택해 주세요.',
                key: ValueKey('town_${ref.read(analyticsSelectedCountryProvider) ?? ""}_${ref.read(analyticsSelectedCityProvider) ?? ""}_${townList.length}'),
                onChanged: (selectedTown) {
                  // 선택된 동네 이름 저장 (분석 탭 전용 Provider 사용)
                  ref.read(analyticsSelectedTownProvider.notifier).state =
                      selectedTown;

                  // 필터링 정보 전달
                  _updateFilters();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 선택된 필터 정보를 상위 위젯에 전달
  void _updateFilters() {
    // 드롭다운에서 선택된 값 (이름으로 직접 필터링하기 위해 이름만 전달)
    final selectedCountry = ref.read(analyticsSelectedCountryProvider);
    final selectedCity = ref.read(analyticsSelectedCityProvider);
    final selectedTown = ref.read(analyticsSelectedTownProvider);

    // 필터링 정보 전달 (선택되지 않은 경우 null 전달)
    widget.onLocationChanged(
      countryName: selectedCountry,
      cityName: selectedCity,
      townName: selectedTown,
    );
  }

  // 이름 기반 필터링을 사용하므로 ID 조회 메서드는 더 이상 필요하지 않음
}
