// lib/features/analytics/presentation/widget/analytics_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/widgets/custom_drop_down_button_string.dart';

import '../../../../core/config/screen_size.dart';
import '../../../../model/region_info_model.dart';
import '../../../../widgets/search_text_field.dart';
import '../../../region/presentation/region_info_provider.dart';

class AnalyticsHeader extends ConsumerStatefulWidget {
  final void Function(String pcName) onSearch;
  final void Function({int? countryTbId, int? cityTbId, int? townTbId})
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
                  // 선택된 국가 이름 저장
                  ref.read(selectedCountryProvider.notifier).state =
                      selectedCountry;
                  // 선택된 도시 초기화
                  ref.read(selectedCityProvider.notifier).state = null;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

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
                    'city_${ref.read(selectedCountryProvider) ?? ""}_${cityList.length}'),
                onChanged: (selectedCity) {
                  // 선택된 도시 이름 저장
                  ref.read(selectedCityProvider.notifier).state = selectedCity;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

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
                    'town_${ref.read(selectedCountryProvider) ?? ""}_${ref.read(selectedCityProvider) ?? ""}_${townList.length}'),
                onChanged: (selectedTown) {
                  // 선택된 동네 이름 저장
                  ref.read(selectedTownProvider.notifier).state = selectedTown;

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
                  // 선택된 국가 이름 저장
                  ref.read(selectedCountryProvider.notifier).state =
                      selectedCountry;
                  // 선택된 도시 초기화
                  ref.read(selectedCityProvider.notifier).state = null;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

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
                    'city_${ref.read(selectedCountryProvider) ?? ""}_${cityList.length}'),
                onChanged: (selectedCity) {
                  // 선택된 도시 이름 저장
                  ref.read(selectedCityProvider.notifier).state = selectedCity;
                  // 선택된 동네 초기화
                  ref.read(selectedTownProvider.notifier).state = null;

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
                    'town_${ref.read(selectedCountryProvider) ?? ""}_${ref.read(selectedCityProvider) ?? ""}_${townList.length}'),
                onChanged: (selectedTown) {
                  // 선택된 동네 이름 저장
                  ref.read(selectedTownProvider.notifier).state = selectedTown;

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
    final regionInfo = ref.read(regionInfoProvider);
    final selectedCountry = ref.read(selectedCountryProvider);
    final selectedCity = ref.read(selectedCityProvider);
    final selectedTown = ref.read(selectedTownProvider);

    int? countryTbId;
    int? cityTbId;
    int? townTbId;

    if (selectedCountry != null) {
      // 국가 ID 찾기
      final countryModel = regionInfo.countries.firstWhere(
        (country) => country.countryName == selectedCountry,
        orElse: () => CountryModel(countryId: 0, countryName: ''),
      );
      countryTbId = countryModel.countryId;

      if (selectedCity != null && countryModel.countryId != 0) {
        // 도시 ID 찾기
        final cityModel = countryModel.cityDatas.firstWhere(
          (city) => city.cityName == selectedCity,
          orElse: () => CityModel(cityId: 0, cityName: ''),
        );
        cityTbId = cityModel.cityId;

        if (selectedTown != null && cityModel.cityId != 0) {
          // 동네 ID 찾기
          final townModel = cityModel.townDatas.firstWhere(
            (town) => town.townName == selectedTown,
            orElse: () => TownModel(townId: 0, townName: ''),
          );
          townTbId = townModel.townId;
        }
      }
    }

    // 필터링 정보 전달
    widget.onLocationChanged(
      countryTbId: countryTbId,
      cityTbId: cityTbId,
      townTbId: townTbId,
    );
  }
}
