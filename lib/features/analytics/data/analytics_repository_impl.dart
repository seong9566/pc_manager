import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/analytics/data/analytics_repository_interface.dart';
import 'package:ip_manager/features/analytics/data/analytics_service.dart';
import 'package:ip_manager/model/response_model.dart';
import 'package:ip_manager/model/time_count_model.dart';

final analyticsRepositoryProvider = Provider<IAnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl(ref.read(analyticsServiceProvider));
});

class AnalyticsRepositoryImpl implements IAnalyticsRepository {
  final AnalyticsService analyticsService;

  AnalyticsRepositoryImpl(this.analyticsService);

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
    debugPrint("[Flutter] >> 전체 분석 : ${response.data}");

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

    debugPrint("[Flutter] >> 기간 선택 : ${response.data}");
    return ResponseModel<List<PcStatModel>>.fromJson(
      response.data,
      (json) => List<PcStatModel>.from(
        (json as List).map((e) => PcStatModel.fromJson(e)),
      ),
    );
  }
}
