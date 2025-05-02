// lib/features/analytics/presentation/analytics_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/extension/date_time_extension.dart';
import 'package:ip_manager/features/analytics/domain/analytics_use_case.dart';
import 'package:ip_manager/model/time_count_model.dart';

class AnalyticsState {
  final bool isLoading; // 로딩 상태
  final List<PcRoomAnalytics> thisDayData;
  final List<PcStatModel> daysData;
  final List<PcStatModel> monthData;
  final List<PcStatModel> periodData;

  AnalyticsState({
    this.isLoading = false,
    required this.thisDayData,
    required this.daysData,
    required this.monthData,
    required this.periodData,
  });

  factory AnalyticsState.initial() => AnalyticsState(
        isLoading: false,
        thisDayData: [],
        daysData: [],
        monthData: [],
        periodData: [],
      );

  AnalyticsState copyWith({
    bool? isLoading,
    List<PcRoomAnalytics>? thisDayData,
    List<PcStatModel>? daysData,
    List<PcStatModel>? monthData,
    List<PcStatModel>? periodData,
  }) =>
      AnalyticsState(
        isLoading: isLoading ?? this.isLoading,
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

  // 원본 데이터 보관용
  List<PcRoomAnalytics> _allThisDayData = [];
  List<PcStatModel> _allDaysData = [];
  List<PcStatModel> _allMonthData = [];
  List<PcStatModel> _allPeriodData = [];

  String _searchPcName = '';

  /// 초기 데이터 로드
  Future<void> init() async {
    // 첫 화면 진입 시에도 로딩 토글
    // 최초에는 전체 분석 기록만 -> 탭 선택 시 마다 각 데이터 가져오기.
    state = state.copyWith(isLoading: true);
    try {
      final now = DateTime.now().toDateOnlyForDateTime();
      await getThisDayDataList(targetDate: now);
      // final dayDate = DateTime(now.year, now.month, now.day);
      // final startDate = now;
      // final endDate = now.add(const Duration(days: 1));
      // await getPeriodDataList(startDate: startDate, endDate: endDate);
      // final monthDate = DateTime(now.year, now.month);
      // await getMonthDataList(targetDate: monthDate);
      // await getDaysDataList(targetDate: dayDate);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 전체 분석 기록
  Future<void> getThisDayDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await analyticsUseCase.getThisDayData(
        targetDate: targetDate,
        pcName: pcName,
        countryTbId: countryTbId,
        townTbId: townTbId,
        cityTbId: cityTbId,
      );
      _allThisDayData = data ?? [];
      _applyFilters();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 일별 분석 기록
  Future<void> getDaysDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await analyticsUseCase.getDaysData(
        targetDate: targetDate,
        pcName: pcName,
        countryTbId: countryTbId,
        townTbId: townTbId,
        cityTbId: cityTbId,
      );
      _allDaysData = data ?? [];
      _applyFilters();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 월별 분석 기록
  Future<void> getMonthDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await analyticsUseCase.getMonthData(
        targetDate: targetDate,
        pcName: pcName,
        countryTbId: countryTbId,
        townTbId: townTbId,
        cityTbId: cityTbId,
      );
      _allMonthData = data ?? [];
      _applyFilters();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 기간별 분석 기록
  Future<void> getPeriodDataList({
    required DateTime startDate,
    required DateTime endDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await analyticsUseCase.getPeriodData(
        startDate: startDate,
        endDate: endDate,
        pcName: pcName,
        countryTbId: countryTbId,
        townTbId: townTbId,
        cityTbId: cityTbId,
      );
      _allPeriodData = data ?? [];
      _applyFilters();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 검색어 세팅
  void searchPcName(String pcName) {
    _searchPcName = pcName;
    _applyFilters();
  }

  /// 필터 적용 함수(검색어만)
  void _applyFilters() {
    final t = _searchPcName;
    final fThisDay = t.isEmpty
        ? _allThisDayData
        : _allThisDayData.where((e) => e.pcRoomName.contains(t)).toList();
    final fDays = t.isEmpty
        ? _allDaysData
        : _allDaysData.where((e) => e.pcName.contains(t)).toList();
    final fMonth = t.isEmpty
        ? _allMonthData
        : _allMonthData.where((e) => e.pcName.contains(t)).toList();
    final fPeriod = t.isEmpty
        ? _allPeriodData
        : _allPeriodData.where((e) => e.pcName.contains(t)).toList();

    state = state.copyWith(
      thisDayData: fThisDay,
      daysData: fDays,
      monthData: fMonth,
      periodData: fPeriod,
    );
  }

  /// countryTbId 변경
  Future<void> changeCountry(
    int countryTbId,
    DateTime allDate,
    DateTime dailyDate,
    DateTime monthlyDate,
    DateTime? periodStart,
    DateTime? periodEnd,
  ) async {
    // 전체 탭부터 순차 호출
    await getThisDayDataList(
      targetDate: allDate,
      countryTbId: countryTbId,
    );
    await getDaysDataList(
      targetDate: dailyDate,
      countryTbId: countryTbId,
    );
    await getMonthDataList(
      targetDate: monthlyDate,
      countryTbId: countryTbId,
    );
    if (periodStart != null && periodEnd != null) {
      await getPeriodDataList(
        startDate: periodStart,
        endDate: periodEnd,
        countryTbId: countryTbId,
      );
    }
  }
}

final analyticsViewModelProvider =
    StateNotifierProvider<AnalyticsViewModel, AnalyticsState>((ref) {
  return AnalyticsViewModel(ref.read(analyticsUseCaseProvider));
});

enum AnalyticsType {
  all, // 전체 분석기록
  period, // 기간별 분석
  monthly, // 월별 분석
  daily, // 일별 분석
}
