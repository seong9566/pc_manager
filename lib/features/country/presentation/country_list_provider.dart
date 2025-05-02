import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/country_info_model.dart';
import '../domain/country_use_case.dart';

/// 화면에서 직접 watch 할 수 있는 StateNotifierProvider
final countryListProvider =
    StateNotifierProvider<CountryListNotifier, List<CountryInfoModel>>((ref) {
  return CountryListNotifier(ref.read(countryUseCaseProvider));
});

class CountryListNotifier extends StateNotifier<List<CountryInfoModel>> {
  final CountryUseCase _useCase;

  CountryListNotifier(this._useCase) : super([]);

  Future<void> init() async {
    Future.delayed(Duration(milliseconds: 1000));
    try {
      final list = await _useCase.getCountryList();
      state = list;
    } catch (e) {
      state = [];
    }
  }

  /// 필요하면 화면에서 리프레시용으로 직접 호출 가능
  Future<void> refresh() => init();
}
