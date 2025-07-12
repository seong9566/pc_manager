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

  // 지역 필터링 값 저장
  String? _countryName;
  String? _cityName;
  String? _townName;

  /// 필터 적용 함수(검색어와 지역 필터 모두 적용)
  void _applyFilters() {
    final searchText = _searchPcName;

    // 검색어와 지역 필터 모두 적용
    var fThisDay = _allThisDayData;
    var fDays = _allDaysData;
    var fMonth = _allMonthData;
    var fPeriod = _allPeriodData;

    // 1. 검색어 필터링
    if (searchText.isNotEmpty) {
      fThisDay =
          fThisDay.where((e) => e.pcRoomName.contains(searchText)).toList();
      fDays = fDays.where((e) => e.pcName.contains(searchText)).toList();
      fMonth = fMonth.where((e) => e.pcName.contains(searchText)).toList();
      fPeriod = fPeriod.where((e) => e.pcName.contains(searchText)).toList();
    }

    // 2. 지역명 필터링 (이름 부분 일치 사용)
    if (_countryName != null && _countryName!.isNotEmpty) {
      fThisDay =
          fThisDay.where((e) => e.countryName.contains(_countryName!)).toList();
      fDays =
          fDays.where((e) => e.countryName.contains(_countryName!)).toList();
      fMonth =
          fMonth.where((e) => e.countryName.contains(_countryName!)).toList();
      fPeriod =
          fPeriod.where((e) => e.countryName.contains(_countryName!)).toList();
    }

    // 3. 도시명 필터링
    if (_cityName != null && _cityName!.isNotEmpty) {
      fThisDay =
          fThisDay.where((e) => e.cityName.contains(_cityName!)).toList();
      fDays = fDays.where((e) => e.cityName.contains(_cityName!)).toList();
      fMonth = fMonth.where((e) => e.cityName.contains(_cityName!)).toList();
      fPeriod = fPeriod.where((e) => e.cityName.contains(_cityName!)).toList();
    }

    // 4. 동네명 필터링
    if (_townName != null && _townName!.isNotEmpty) {
      fThisDay =
          fThisDay.where((e) => e.townName.contains(_townName!)).toList();
      fDays = fDays.where((e) => e.townName.contains(_townName!)).toList();
      fMonth = fMonth.where((e) => e.townName.contains(_townName!)).toList();
      fPeriod = fPeriod.where((e) => e.townName.contains(_townName!)).toList();
    }

    state = state.copyWith(
      thisDayData: fThisDay,
      daysData: fDays,
      monthData: fMonth,
      periodData: fPeriod,
    );
  }

  /// 이름으로 지역 필터 변경 (ID 대신 이름으로 필터링)
  Future<void> changeLocationFilter({
    String? countryName,
    String? cityName,
    String? townName,
    required DateTime allDate,
    required DateTime dailyDate,
    required DateTime monthlyDate,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) async {
    // 필터링 값 저장
    _countryName = countryName;
    _cityName = cityName;
    _townName = townName;

    // 기존 데이터에 필터 적용
    _applyFilters();

    // 새로운 데이터 로드는 필요 없음 - 이미 로드된 데이터에 클라이언트 측 필터링만 적용
  }

  /// 모든 필터 초기화
  Future<void> resetFilters() async {
    // 검색어 초기화
    _searchPcName = '';

    // 지역 필터 초기화
    _countryName = null;
    _cityName = null;
    _townName = null;

    // 필터 적용 (원본 데이터로 복원)
    _applyFilters();
  }

  /// 기존 API 호출을 위한 메서드 (하위 호환성 유지)
  @Deprecated('ID 대신 이름 기반 필터링을 사용하세요')
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
