import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/network/api_endpoints.dart';

import '../../../core/network/api_client.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.read(apiClientProvider));
});

class AnalyticsService {
  final ApiClient apiClient;

  AnalyticsService(this.apiClient);

  Future<Response> getThisDayData({required Map<String, Object?> data}) async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getThisDayDataList,
      data: data,
    );
  }

  Future<Response> getMonthDataList(
      {required Map<String, Object?> data}) async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getMonthDataList,
      data: data,
    );
  }

  Future<Response> getDaysDataList({required Map<String, Object?> data}) async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getDaysDataList,
      data: data,
    );
  }

  Future<Response> getPeriodList({required Map<String, Object?> data}) async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getPeriodList,
      data: data,
    );
  }
}
