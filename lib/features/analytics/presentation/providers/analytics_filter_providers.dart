import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/region/presentation/region_info_provider.dart';

// 분석 화면 전용 선택된 지역 Provider
final analyticsSelectedCountryProvider = StateProvider<String?>((ref) => null);

// 분석 화면 전용 선택된 도시 Provider
final analyticsSelectedCityProvider = StateProvider<String?>((ref) => null);

// 분석 화면 전용 선택된 동네 Provider
final analyticsSelectedTownProvider = StateProvider<String?>((ref) => null);

// 분석 화면 전용 도시 목록 Provider
final analyticsCityNamesByCountryProvider = Provider<List<String>>((ref) {
  final selectedCountry = ref.watch(analyticsSelectedCountryProvider);
  
  if (selectedCountry == null) return [];
  
  return ref
      .read(regionInfoProvider.notifier)
      .getCitiesByCountryName(selectedCountry)
      .map((city) => city.cityName)
      .toList();
});

// 분석 화면 전용 동네 목록 Provider
final analyticsTownNamesByCountryCityProvider = Provider<List<String>>((ref) {
  final selectedCountry = ref.watch(analyticsSelectedCountryProvider);
  final selectedCity = ref.watch(analyticsSelectedCityProvider);

  if (selectedCountry == null || selectedCity == null) return [];

  return ref
      .read(regionInfoProvider.notifier)
      .getTownsByCityName(selectedCountry, selectedCity)
      .map((town) => town.townName)
      .toList();
});
