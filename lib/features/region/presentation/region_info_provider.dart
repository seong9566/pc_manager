import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/region_info_model.dart';
import '../domain/region_use_case.dart';

/// 지역 정보 Provider - 앱 시작 시 자동으로 초기화됨
final regionInfoProvider =
    StateNotifierProvider<RegionInfoNotifier, RegionInfoModel>((ref) {
  final notifier = RegionInfoNotifier(ref.read(regionUseCaseProvider));
  // Provider 생성 시 자동으로 초기화
  notifier.init();
  return notifier;
});

/// 국가(지역) 이름 목록 Provider
final countryNameListProvider = Provider<List<String>>((ref) {
  final regionInfo = ref.watch(regionInfoProvider);
  return ref.read(regionUseCaseProvider).extractCountryNames(regionInfo);
});

final cityListProvider = Provider<List<String>>((ref) {
  final regionInfo = ref.watch(regionInfoProvider);
  return ref.read(regionUseCaseProvider).extractCityNames(regionInfo);
});

final selectedCountryProvider = StateProvider<String?>((ref) => null);

final cityNamesByCountryProvider = Provider<List<String>>((ref) {
  final selectedCountry = ref.watch(selectedCountryProvider);

  if (selectedCountry == null) return [];

  return ref
      .read(regionInfoProvider.notifier)
      .getCitiesByCountryName(selectedCountry)
      .map((city) => city.cityName)
      .toList();
});

/// 선택된 도시 Provider
final selectedCityProvider = StateProvider<String?>((ref) => null);

/// 선택된 국가와 도시에 따른 동네 목록 Provider
final townNamesByCountryCityProvider = Provider<List<String>>((ref) {
  final selectedCountry = ref.watch(selectedCountryProvider);
  final selectedCity = ref.watch(selectedCityProvider);

  if (selectedCountry == null || selectedCity == null) return [];

  return ref
      .read(regionInfoProvider.notifier)
      .getTownsByCityName(selectedCountry, selectedCity)
      .map((town) => town.townName)
      .toList();
});

/// 선택된 동네 Provider
final selectedTownProvider = StateProvider<String?>((ref) => null);

class RegionInfoNotifier extends StateNotifier<RegionInfoModel> {
  final RegionUseCase _useCase;

  RegionInfoNotifier(this._useCase) : super(RegionInfoModel());

  /// 초기화 및 데이터 로드
  Future<void> init() async {
    try {
      final regionInfo = await _useCase.getRegionInfo();
      state = regionInfo;
      for (final a in regionInfo.countries) {}
    } catch (e) {
      debugPrint("[Flutter] >> RegionInfoNotifier init error: $e");
      // 에러 발생 시 빈 모델 유지
    }
  }

  /// 데이터 새로고침
  Future<void> refresh() => init();

  /// 특정 도시(countryName)에 해당하는 도시(city) 목록 반환
  List<CityModel> getCitiesByCountryName(String countryName) {
    final country = state.countries.firstWhere(
      (country) => country.countryName == countryName,
      orElse: () => CountryModel(countryId: 0, countryName: ''),
    );
    return country.cityDatas;
  }

  /// 특정 도시(cityName)에 해당하는 동네(town) 목록 반환
  List<TownModel> getTownsByCityName(String countryName, String cityName) {
    final cities = getCitiesByCountryName(countryName);
    final city = cities.firstWhere(
      (city) => city.cityName == cityName,
      orElse: () => CityModel(cityId: 0, cityName: ''),
    );
    return city.townDatas;
  }
}
