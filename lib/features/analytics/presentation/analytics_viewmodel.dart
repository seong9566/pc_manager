import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/extension/date_time_extension.dart';
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

  // 원본 데이터 보관용
  List<PcRoomAnalytics> _allThisDayData = [];
  List<PcStatModel> _allDaysData = [];
  List<PcStatModel> _allMonthData = [];
  List<PcStatModel> _allPeriodData = [];

  String _searchPcName = '';

  // 초기엔 모두 오늘 날
  Future<void> init() async {
    await Future.delayed(Duration(seconds: 1));
    final DateTime now = DateTime.now();
    final DateTime dayDate = DateTime(now.year, now.month, now.day);
    getThisDayDataList(targetDate: now.toDateOnlyForDateTime());

    await Future.delayed(Duration(seconds: 1));
    final DateTime startDate = now.toDateOnlyForDateTime();
    final DateTime endDate = startDate.add(const Duration(days: 1));
    getPeriodDataList(startDate: startDate, endDate: endDate);

    await Future.delayed(Duration(seconds: 1));
    final DateTime monthDate = DateTime(now.year, now.month);
    getMonthDataList(targetDate: monthDate);

    await Future.delayed(Duration(seconds: 1));
    getDaysDataList(targetDate: dayDate);
  }

  /// 전체 분석 록록
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

    _allThisDayData = data ?? [];
    _applyFilters();
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

    _allDaysData = data ?? [];
    _applyFilters();
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

    _allMonthData = data ?? [];
    _applyFilters();
  }

  Future<void> getPeriodDataList({
    required DateTime startDate,
    required DateTime endDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  }) async {
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
  }

  /// 검색어 세팅
  void searchPcName(String pcName) {
    _searchPcName = pcName;
    _applyFilters();
  }

  /// Apply current search term to all data sets
  /// 현재 _searchTerm 기준으로 모두 필터링
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

  /// countryTbId 가 바뀌었을 때, 모든 탭(전체/일/월/기간)을 순차 호출
  Future<void> changeCountry(
      int countryTbId,
      DateTime allDate,
      DateTime dailyDate,
      DateTime monthlyDate,
      DateTime? periodStart,
      DateTime? periodEnd) async {
    // 전체
    await getThisDayDataList(targetDate: allDate, countryTbId: countryTbId);
    // 일별
    await getDaysDataList(targetDate: dailyDate, countryTbId: countryTbId);
    // 월별
    await getMonthDataList(targetDate: monthlyDate, countryTbId: countryTbId);
    // 기간별
    if (periodStart != null && periodEnd != null) {
      await getPeriodDataList(
          startDate: periodStart, endDate: periodEnd, countryTbId: countryTbId);
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
