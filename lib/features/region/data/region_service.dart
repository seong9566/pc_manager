import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

/// 지역 정보 서비스 Provider
final regionServiceProvider = Provider<RegionService>((ref) {
  return RegionService(ref.read(apiClientProvider));
});

/// 지역 정보 API 서비스
class RegionService {
  final ApiClient _apiClient;

  RegionService(this._apiClient);

  /// 서버에서 지역 정보 데이터를 가져옵니다.
  Future<Response> getRegionInfo() async {
    return _apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.regionInfo,
    );
  }
}
