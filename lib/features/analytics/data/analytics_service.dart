import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/network/api_endpoints.dart';

import '../../../core/network/api_client.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.read(apiClientProvider));
});

class AnalyticsService {
  final ApiClient apiClient;

  AnalyticsService(this.apiClient);

  Future<Map<String, dynamic>> getExcelData(
      {required Map<String, Object?> data}) async {
    try {
      final response = await apiClient.request(
        DioMethod.get,
        url: ApiEndPoints.getExcelList,
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        debugPrint('엑셀 데이터 응답 실패: ${response.statusCode}');
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('엑셀 데이터 요청 오류: $e');
      throw Exception('엑셀 데이터 요청 중 오류 발생: $e');
    }
  }

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
