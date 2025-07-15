import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/analytics/data/analytics_repository_impl.dart';
import '../../../model/time_count_model.dart';
import '../data/analytics_repository_interface.dart';
import '../data/models/excel_data_model.dart';

/// 데이터 필터링, 유효성 검사, 조건 분기 등

final analyticsUseCaseProvider = Provider<AnalyticsUseCase>((ref) {
  return AnalyticsUseCase(ref.read(analyticsRepositoryProvider));
});

class AnalyticsUseCase {
  final IAnalyticsRepository analyticsRepository;

  AnalyticsUseCase(this.analyticsRepository);

  Future<ExcelDataResponse> getExcelData({
    required DateTime startDate,
    required DateTime endDate,
    required List<int> pcId,
  }) async {
    try {
      final result = await analyticsRepository.getExcelData(
        startDate: startDate,
        endDate: endDate,
        pcId: pcId,
      );
      
      return result;
    } catch (e) {
      debugPrint('UseCase에서 엑셀 데이터 처리 중 오류: $e');
      throw Exception('엑셀 데이터 처리 중 오류가 발생했습니다');
    }
  }

  Future<List<PcRoomAnalytics>?> getThisDayData({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final result = await analyticsRepository.getThisDayData(
      targetDate: targetDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    if (result.code != 200) {
      debugPrint('[UseCase] getThisDayData failed: ${result.message}');
      return null;
    }

    return result.data;
  }

  Future<List<PcStatModel>?> getDaysData({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final result = await analyticsRepository.getDaysDataList(
      targetDate: targetDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    if (result.code != 200) {
      debugPrint('[UseCase] getDaysData failed: ${result.message}');
      return null;
    }

    return result.data;
  }

  Future<List<PcStatModel>?> getMonthData({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final result = await analyticsRepository.getMonthDataList(
      targetDate: targetDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    if (result.code != 200) {
      debugPrint('[UseCase] getMonthData failed: ${result.message}');
      return null;
    }

    return result.data;
  }

  Future<List<PcStatModel>?> getPeriodData({
    required DateTime startDate,
    required DateTime endDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final result = await analyticsRepository.getPeriodList(
      startDate: startDate,
      endDate: endDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    if (result.code != 200) {
      debugPrint('[UseCase] getPeriodData failed: ${result.message}');
      return null;
    }

    return result.data;
  }
}
