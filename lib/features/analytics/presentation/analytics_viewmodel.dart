import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/analytics/domain/analytics_use_case.dart';
import 'package:ip_manager/model/time_count_model.dart';

class AnalyticsState {
  final List<PcRoomAnalytics> thisDayData;
  final List<PcStatModel> daysData;
  final List<PcStatModel> monthData;
  final List<PcStatModel> periodData;

  AnalyticsState({
    required this.thisDayData,
    required this.daysData,
    required this.monthData,
    required this.periodData,
  });

  factory AnalyticsState.initial() => AnalyticsState(
        thisDayData: [],
        daysData: [],
        monthData: [],
        periodData: [],
      );

  AnalyticsState copyWith({
    List<PcRoomAnalytics>? thisDayData,
    List<PcStatModel>? daysData,
    List<PcStatModel>? monthData,
    List<PcStatModel>? periodData,
  }) =>
      AnalyticsState(
        thisDayData: thisDayData ?? this.thisDayData,
        daysData: daysData ?? this.daysData,
        monthData: monthData ?? this.monthData,
        periodData: periodData ?? this.periodData,
      );
}

class AnalyticsViewModel extends StateNotifier<AnalyticsState> {
  final AnalyticsUseCase analyticsUseCase;

  AnalyticsViewModel(this.analyticsUseCase) : super(AnalyticsState.initial()) {
    init();
  }

  Future<void> init() async {
    /// TODO : 테스트를 위한 04-05 데이터로 셋팅
    // final DateTime now = DateTime.parse('2025-04-05');
    final DateTime now = DateTime.now();
    await Future.delayed(Duration(seconds: 1));
    getThisDayDataList(targetDate: now);
  }

  Future<void> getThisDayDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = await analyticsUseCase.getThisDayData(
      targetDate: targetDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    state = state.copyWith(thisDayData: data ?? []);

    state = state.copyWith(thisDayData: data);
  }

  Future<void> getDaysDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = await analyticsUseCase.getDaysData(
      targetDate: targetDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    state = state.copyWith(daysData: data ?? []);
  }

  Future<void> getMonthDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = await analyticsUseCase.getMonthData(
      targetDate: targetDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    state = state.copyWith(monthData: data ?? []);
  }

  Future<void> getPeriodDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    final data = await analyticsUseCase.getPeriodData(
      targetDate: targetDate,
      pcName: pcName,
      countryTbId: countryTbId,
      townTbId: townTbId,
      cityTbId: cityTbId,
    );

    state = state.copyWith(periodData: data ?? []);
  }
}

final analyticsViewModelProvider =
    StateNotifierProvider<AnalyticsViewModel, AnalyticsState>((ref) {
  return AnalyticsViewModel(ref.read(analyticsUseCaseProvider));
});
