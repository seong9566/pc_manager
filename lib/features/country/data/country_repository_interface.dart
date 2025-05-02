import '../../../model/country_info_model.dart';

/// Repository 인터페이스: UseCase → Service 사이, DTO ↔ Model 변환 지점
abstract class ICountryRepository {
  /// 국가 리스트를 JSON → CountryInfoModel 리스트로 변환해 반환
  Future<List<CountryInfoModel>> getCountryList();
}
