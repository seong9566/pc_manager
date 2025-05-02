import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/country_info_model.dart';
import '../data/country_repository_interface.dart';
import '../data/country_repository_impl.dart';

/// UseCase 를 Provider 로 등록
final countryUseCaseProvider = Provider<CountryUseCase>((ref) {
  return CountryUseCase(ref.read(countryRepositoryProvider));
});

class CountryUseCase {
  final ICountryRepository _repo;

  CountryUseCase(this._repo);

  /// 순수하게 비즈니스 로직만 담아두고, Repository 호출
  Future<List<CountryInfoModel>> getCountryList() {
    return _repo.getCountryList();
  }
}
