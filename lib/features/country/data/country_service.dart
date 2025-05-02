import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

/// Service: 실제 HTTP 요청을 담당
final countryServiceProvider = Provider<CountryService>((ref) {
  return CountryService(ref.read(apiClientProvider));
});

class CountryService {
  final ApiClient _apiClient;

  CountryService(this._apiClient);

  /// 서버에서 Country 리스트를 가져옵니다.
  Future<Response> getCountryInfoList() async {
    return _apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getCountryInfo,
    );
  }
}
