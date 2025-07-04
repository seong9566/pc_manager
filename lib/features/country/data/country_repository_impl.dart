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
    
    // countryName만 추출하여 중복 없이 리스트로 만듦
    final Set<String> uniqueCountryNames = {};
    final List<CountryInfoModel> result = [];
    
    for (var item in parsed.data) {
      // countryName이 있고 비어있지 않은 경우에만 추가
      if (item['countryName'] != null && item['countryName'].toString().isNotEmpty) {
        final countryName = item['countryName'].toString();
        // 중복 제거
        if (!uniqueCountryNames.contains(countryName)) {
          uniqueCountryNames.add(countryName);
          result.add(CountryInfoModel(
            pId: item['countryId'] is int
                ? item['countryId'] as int
                : int.tryParse(item['countryId'].toString()) ?? 0,
            countryName: countryName,
          ));
        }
      }
    }
    
    return result;
  }
}
