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
  final VoidCallback onReset; // 초기화 버튼 클릭시 호출될 콜백

  const AnalyticsHeader({
    super.key,
    required this.onSearch,
    required this.onLocationChanged,
    required this.onReset,
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
        // 검색창과 초기화 버튼을 한 줄에 배치
        Row(
          children: [
            Expanded(
              child: SearchTextField(
                hintText: 'PC방 이름으로 검색',
                controller: _controller,
                onChanged: (text) => widget.onSearch(text.trim()),
                onComplete: () => widget.onSearch(_controller.text.trim()),
              ),
            ),
            const SizedBox(width: 8),
            // 모바일용 간소화된 초기화 버튼
            ElevatedButton(
              onPressed: _resetFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                side:
                    BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                minimumSize: const Size(60, 50), // 검색창과 동일한 높이
                maximumSize: const Size(60, 50),
              ),
              child: const Icon(Icons.refresh, size: 16),
            ),
          ],
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
                selectedValue: ref.watch(analyticsSelectedCountryProvider),
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
                selectedValue: ref.watch(analyticsSelectedCityProvider),
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
                key: ValueKey(
                    'town_${ref.read(analyticsSelectedCountryProvider) ?? ""}_${ref.read(analyticsSelectedCityProvider) ?? ""}_${townList.length}'),
                selectedValue: ref.watch(analyticsSelectedTownProvider),
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
              child: Row(
                children: [
                  Expanded(
                    child: SearchTextField(
                      hintText: 'PC방 이름으로 검색',
                      controller: _controller,
                      onChanged: (text) => widget.onSearch(text.trim()),
                      onComplete: () =>
                          widget.onSearch(_controller.text.trim()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 반응형 버튼 - 데스크탑 레이아웃에서는 더 여유롭게 표시
                  ElevatedButton.icon(
                    onPressed: _resetFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                          color: Colors.redAccent.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      minimumSize: const Size(120, 48), // 검색창과 동일한 높이 설정
                      maximumSize: const Size(180, 48),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(
                      '필터 초기화',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
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
                selectedValue: ref.watch(analyticsSelectedCountryProvider),
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
                selectedValue: ref.watch(analyticsSelectedCityProvider),
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
                key: ValueKey(
                    'town_${ref.read(analyticsSelectedCountryProvider) ?? ""}_${ref.read(analyticsSelectedCityProvider) ?? ""}_${townList.length}'),
                selectedValue: ref.watch(analyticsSelectedTownProvider),
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

  // 모든 필터 초기화
  void _resetFilters() {
    // 검색어 초기화
    _controller.clear();

    // 드롭다운 선택 초기화
    ref.read(analyticsSelectedCountryProvider.notifier).state = null;
    ref.read(analyticsSelectedCityProvider.notifier).state = null;
    ref.read(analyticsSelectedTownProvider.notifier).state = null;

    // 콜백 호출
    widget.onSearch('');
    widget.onLocationChanged(
      countryName: null,
      cityName: null,
      townName: null,
    );

    // 상위 콜백 호출
    widget.onReset();
  }

  // 이름 기반 필터링을 사용하므로 ID 조회 메서드는 더 이상 필요하지 않음
}
