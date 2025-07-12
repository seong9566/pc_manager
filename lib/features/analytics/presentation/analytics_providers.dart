import 'package:flutter_riverpod/flutter_riverpod.dart';

// 분석 화면 전용 선택된 국가/도시/동네 Provider
final analyticsSelectedCountryProvider = StateProvider<String?>((ref) => null);
final analyticsSelectedCityProvider = StateProvider<String?>((ref) => null);
final analyticsSelectedTownProvider = StateProvider<String?>((ref) => null);
