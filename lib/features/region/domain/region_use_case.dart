import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/region_info_model.dart';
import '../data/region_repository_interface.dart';
import '../data/region_repository_impl.dart';

/// 지역 정보 유스케이스 Provider
final regionUseCaseProvider = Provider<RegionUseCase>((ref) {
  return RegionUseCase(ref.read(regionRepositoryProvider));
});

/// 지역 정보 유스케이스
class RegionUseCase {
  final IRegionRepository _repository;

  RegionUseCase(this._repository);

  /// 지역 정보 데이터를 가져옵니다.
  Future<RegionInfoModel> getRegionInfo() async {
    try {
      return await _repository.getRegionInfo();
    } catch (e) {
      // 에러 발생 시 빈 모델 반환
      return RegionInfoModel();
    }
  }

  /// 도시 이름 목록 추출
  List<String> extractCityNames(RegionInfoModel regionInfo) {
    final List<String> countryName = [];

    for (final country in regionInfo.countries) {
      countryName.add(country.countryName);
    }
    // for (final city in regionInfo.cityDatas) {
    //   if (city.cityName.isNotEmpty) {
    //     cityNames.add(city.cityName);
    //   }
    // }

    return countryName;
  }

  /// 국가(지역) 이름 목록 추출
  /// 모든 국가(country) 이름을 추출하여 리스트로 반환
  List<String> extractCountryNames(RegionInfoModel regionInfo) {
    final List<String> countryNames = [];

    for (final country in regionInfo.countries) {
      if (country.countryName.isNotEmpty) {
        countryNames.add(country.countryName);
      }
    }

    return countryNames;
  }
}
