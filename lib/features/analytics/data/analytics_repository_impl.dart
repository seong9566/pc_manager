import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/model/response_model.dart';
import 'package:ip_manager/model/time_count_model.dart';

import 'analytics_repository_interface.dart';
import 'analytics_service.dart';
import 'models/excel_data_model.dart';

final analyticsRepositoryProvider = Provider<IAnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl(ref.read(analyticsServiceProvider));
});

class AnalyticsRepositoryImpl implements IAnalyticsRepository {
  final AnalyticsService analyticsService;

  AnalyticsRepositoryImpl(this.analyticsService);

  @override
  Future<ExcelDataResponse> getExcelData({
    required DateTime startDate,
    required DateTime endDate,
    required List<int> pcId,
  }) async {
    try {
      final data = {
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "pcId": pcId,
      };

      final response = await analyticsService.getExcelData(data: data);
      return ExcelDataResponse.fromJson(response);
    } catch (e) {
      throw Exception('엑셀 데이터 변환 중 오류 발생: $e');
    }
  }

  /// 전체 분석 기록 (시간별 사용량)
  @override
  Future<ResponseModel<List<PcRoomAnalytics>>> getThisDayData({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = {
      "targetDate": targetDate.toIso8601String(),
      "pcName": pcName,
      "countryTbId": countryTbId,
      "townTbId": townTbId,
      "cityTbId": cityTbId,
    };

    final response = await analyticsService.getThisDayData(data: data);

    return ResponseModel<List<PcRoomAnalytics>>.fromJson(
      response.data,
      (json) => List<PcRoomAnalytics>.from(
        (json as List).map((e) => PcRoomAnalytics.fromJson(e)),
      ),
    );
  }

  /// 일별 기록
  @override
  Future<ResponseModel<List<PcStatModel>>> getDaysDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = {
      "target": targetDate.toIso8601String(),
      "pcName": pcName,
      "countryTbId": countryTbId,
      "townTbId": townTbId,
      "cityTbId": cityTbId,
    };

    final response = await analyticsService.getDaysDataList(data: data);
    debugPrint(response.data.toString());
    return ResponseModel<List<PcStatModel>>.fromJson(
      response.data,
      (json) => List<PcStatModel>.from(
        (json as List).map((e) => PcStatModel.fromJson(e)),
      ),
    );
  }

  /// 월별 기록
  @override
  Future<ResponseModel<List<PcStatModel>>> getMonthDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = {
      "targetDate": targetDate.toIso8601String(),
      "pcName": pcName,
      "countryTbId": countryTbId,
      "townTbId": townTbId,
      "cityTbId": cityTbId,
    };

    final response = await analyticsService.getMonthDataList(data: data);

    return ResponseModel<List<PcStatModel>>.fromJson(
      response.data,
      (json) => List<PcStatModel>.from(
        (json as List).map((e) => PcStatModel.fromJson(e)),
      ),
    );
  }

  /// 기간별 기록
  @override
  Future<ResponseModel<List<PcStatModel>>> getPeriodList({
    required DateTime startDate,
    required DateTime endDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = {
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "pcName": pcName,
      "countryTbId": countryTbId,
      "townTbId": townTbId,
      "cityTbId": cityTbId,
    };

    final response = await analyticsService.getPeriodList(data: data);

    return ResponseModel<List<PcStatModel>>.fromJson(
      response.data,
      (json) => List<PcStatModel>.from(
        (json as List).map((e) => PcStatModel.fromJson(e)),
      ),
    );
  }
}
