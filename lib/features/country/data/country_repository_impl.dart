import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/country_info_model.dart';
import '../../../model/response_model.dart';
import 'country_repository_interface.dart';
import 'country_service.dart';

/// Repository 구현체를 Provider 로 등록
final countryRepositoryProvider = Provider<ICountryRepository>((ref) {
  return CountryRepositoryImpl(ref.read(countryServiceProvider));
});

class CountryRepositoryImpl implements ICountryRepository {
  final CountryService _service;

  CountryRepositoryImpl(this._service);

  @override
  Future<List<CountryInfoModel>> getCountryList() async {
    final response = await _service.getCountryInfoList();
    // ResponseModel.fromJson 사용 예시: data 안의 배열을 그대로 꺼내오고, 각 요소를 변환
    final parsed = ResponseModel<List<dynamic>>.fromJson(
      response.data,
      (json) => (json as List).cast<Map<String, dynamic>>(),
    );
    return parsed.data.map((e) => CountryInfoModel.fromJson(e)).toList();
  }
}
