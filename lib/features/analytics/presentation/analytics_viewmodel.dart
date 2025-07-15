// lib/features/analytics/presentation/analytics_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/extension/date_time_extension.dart';
import 'package:ip_manager/core/utils/csv_export_helper.dart';
import 'package:ip_manager/core/utils/csv_export_result.dart';
import 'package:ip_manager/features/analytics/domain/analytics_use_case.dart';
import 'package:ip_manager/model/time_count_model.dart';
import 'package:intl/intl.dart';

// 분석 데이터 유형 정의
enum AnalyticsType {
  all, // 전체 분석기록
  daily, // 일별 분석
  monthly, // 월별 분석
  period, // 기간별 분석
}

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
      await getThisDayData(targetDate: now);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 엑셀 데이터 가져오기
  Future<void> getExcelData({
    required DateTime startDate,
    required DateTime endDate,
    required List<int> pcId,
  }) async {
    try {
      final data = await analyticsUseCase.getExcelData(
        startDate: startDate,
        endDate: endDate,
        pcId: pcId,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 전체 분석 기록
  Future<void> getThisDayData({
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
  Future<void> getDaysData({
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
  Future<void> getMonthData({
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
  Future<void> getPeriodData({
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

  /// 기간별 데이터를 CSV로 내보내기
  /// [type] - 어떤 탭의 데이터를 내보낼 것인지 지정
  /// [startDate] - 기간별 데이터일 경우 시작일
  /// [endDate] - 기간별 데이터일 경우 종료일
  Future<CsvExportResult> exportToCsv({
    required AnalyticsType type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // 1. 데이터 준비
      List<List<dynamic>> csvData = [];
      String fileName = '';
      List<String> headers = [
        '날짜',
        '매장 이름',
        '가동률',
        'PC매출',
        '식품매출',
        '총매출',
      ];

      switch (type) {
        case AnalyticsType.all:
          // 현재 날짜 데이터 변환
          final formattedData = state.thisDayData
              .map((item) => [
                    DateFormat('yyyy.MM.dd').format(DateTime.now()),
                    item.pcRoomName,
                    '${item.analyList.isNotEmpty ? ((item.analyList.length / 24) * 100).toStringAsFixed(2) : '0.00'}%',
                    '0원', // PC매출 데이터가 없으므로 기본값으로 설정
                    '0원', // 식품매출 데이터가 없으므로 기본값으로 설정
                    '0원', // 총매출 데이터가 없으므로 기본값으로 설정
                  ])
              .toList();
          csvData.addAll(formattedData);
          fileName = '전체분석_${DateFormat('yyyyMMdd').format(DateTime.now())}';
          break;

        case AnalyticsType.daily:
          // 일별 데이터 변환
          final formattedData = state.daysData
              .map((item) => [
                    DateFormat('yyyy.MM.dd').format(DateTime.now()),
                    item.pcName,
                    item.averageRate,
                    item.pcPrice,
                    item.foodPrice,
                    item.totalPrice,
                  ])
              .toList();
          csvData.addAll(formattedData);
          fileName = '일별분석_${DateFormat('yyyyMMdd').format(DateTime.now())}';
          break;

        case AnalyticsType.monthly:
          // 월별 데이터 변환
          final formattedData = state.monthData
              .map((item) => [
                    DateFormat('yyyy.MM.dd').format(DateTime.now()),
                    item.pcName,
                    item.averageRate,
                    item.pcPrice,
                    item.foodPrice,
                    item.totalPrice,
                  ])
              .toList();
          csvData.addAll(formattedData);
          fileName = '월별분석_${DateFormat('yyyyMMdd').format(DateTime.now())}';
          break;

        case AnalyticsType.period:
          // 기간별 데이터 변환
          if (startDate != null && endDate != null) {
            final formattedData = state.periodData
                .map((item) => [
                      '${DateFormat('yyyy.MM.dd').format(startDate)} ~ ${DateFormat('yyyy.MM.dd').format(endDate)}',
                      item.pcName,
                      item.averageRate,
                      item.pcPrice,
                      item.foodPrice,
                      item.totalPrice,
                    ])
                .toList();
            csvData.addAll(formattedData);
            fileName =
                '기간분석_${DateFormat('yyyyMMdd').format(startDate)}_${DateFormat('yyyyMMdd').format(endDate)}';
          } else {
            return CsvExportResult(
              success: false,
              message: '기간 설정이 잘못되었습니다.',
            );
          }
          break;
      }

      // CSV 파일로 내보내기
      if (csvData.isEmpty) {
        return CsvExportResult(
          success: false,
          message: '내보낼 데이터가 없습니다.',
        );
      }

      // 2. CSV 파일 생성 및 저장
      final result = await CsvExportHelper.exportToCsv(
        data: csvData,
        headers: headers,
        fileName: fileName,
      );

      return CsvExportResult(
        success: true,
        message: 'CSV 파일이 성공적으로 저장되었습니다.',
        filePath: result,
      );
    } catch (e) {
      debugPrint('CSV 내보내기 오류: $e');
      return CsvExportResult(
        success: false,
        message: '오류가 발생했습니다: $e',
      );
    }
  }

  /// 선택한 PC방과 날짜 범위에 따라 데이터를 필터링하고 CSV로 내보내기
  /// [selectedPcRoomIds] - 선택한 PC방 ID 목록
  /// [startDate] - 시작일
  /// [endDate] - 종료일
  Future<CsvExportResult> exportPcRoomDataToCsv({
    required List<int> selectedPcRoomIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // 로딩 상태로 변경
      state = state.copyWith(isLoading: true);

      // 1. 선택한 기간에 대한 데이터 가져오기
      // 이미 저장된 데이터가 있거나, 필요하다면 API를 호출하여 데이터 가져오기

      // 선택한 PC방만 필터링
      final filteredData = state.thisDayData.where((pcRoom) {
        return selectedPcRoomIds.contains(pcRoom.pcRoomId);
      }).toList();

      // 2. 헤더 및 데이터 준비
      List<String> headers = [
        'PC방 ID',
        'PC방 이름',
        '지역',
        '도시',
        '동네',
        '시간대',
        '이용자 수',
        '날짜'
      ];

      // 3. CSV 데이터 형식으로 변환
      List<List<dynamic>> csvData = [];

      // 필터링된 각 PC방에 대해
      for (var pcRoom in filteredData) {
        // 각 분석 데이터 항목에 대해
        for (var usage in pcRoom.analyList) {
          csvData.add([
            pcRoom.pcRoomId.toString(),
            pcRoom.pcRoomName,
            pcRoom.countryName,
            pcRoom.cityName,
            pcRoom.townName,
            usage.time, // 시간대
            usage.count.toString(), // 이용자 수
            DateFormat('yyyy-MM-dd').format(startDate), // 날짜
          ]);
        }
      }

      if (csvData.isEmpty) {
        state = state.copyWith(isLoading: false);
        return CsvExportResult(
          success: false,
          message: '내보낼 데이터가 없습니다.',
        );
      }

      // 파일 이름 생성 (검색 기간 포함)
      String fileName =
          'PC방분석_${DateFormat('yyyyMMdd').format(startDate)}_${DateFormat('yyyyMMdd').format(endDate)}';

      // 4. CSV 파일 생성 및 저장
      final result = await CsvExportHelper.exportToCsv(
        data: csvData,
        headers: headers,
        fileName: fileName,
      );

      // 로딩 상태 해제
      state = state.copyWith(isLoading: false);

      return CsvExportResult(
        success: true,
        message: 'CSV 파일이 성공적으로 저장되었습니다.',
        filePath: result,
      );
    } catch (e) {
      // 로딩 상태 해제
      state = state.copyWith(isLoading: false);

      debugPrint('CSV 내보내기 오류: $e');
      return CsvExportResult(
        success: false,
        message: '오류가 발생했습니다: $e',
      );
    }
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
    await getThisDayData(
      targetDate: allDate,
      countryTbId: countryTbId,
    );
    await getDaysData(
      targetDate: dailyDate,
      countryTbId: countryTbId,
    );
    await getMonthData(
      targetDate: monthlyDate,
      countryTbId: countryTbId,
    );

    if (periodStart != null && periodEnd != null) {
      await getPeriodData(
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
