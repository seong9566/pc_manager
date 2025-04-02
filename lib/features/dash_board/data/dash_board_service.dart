import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

final dashBoardServiceProvider = Provider<DashBoardService>((ref) {
  return DashBoardService(ref.read(apiClientProvider));
});

class DashBoardService {
  final ApiClient apiClient;

  DashBoardService(this.apiClient);

  Future<Response> getThisTimeDataList() async {
    final data = await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getThisTimeDataList,
    );
    return data;
  }

  Future<Response> getTopAnalyze() async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getTopAnalyzeName,
    );
  }
}
