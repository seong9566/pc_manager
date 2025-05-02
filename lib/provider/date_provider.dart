import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateState {
  // 탭별 독립 날짜
  final DateTime allDate;
  final DateTime dailyDate;
  final DateTime monthlyDate;

  // 기간 시작/끝
  final DateTime? periodStart;
  final DateTime? periodEnd;

  DateState({
    required this.allDate,
    required this.dailyDate,
    required this.monthlyDate,
    this.periodStart,
    this.periodEnd,
  });

  factory DateState.initial() {
    final now = DateTime.now();
    return DateState(
      allDate: now,
      dailyDate: now,
      monthlyDate: DateTime(now.year, now.month),
      periodStart: now.subtract(Duration(days: 1)),
      periodEnd: now,
    );
  }

  DateState copyWith({
    DateTime? allDate,
    DateTime? dailyDate,
    DateTime? monthlyDate,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    return DateState(
      allDate: allDate ?? this.allDate,
      dailyDate: dailyDate ?? this.dailyDate,
      monthlyDate: monthlyDate ?? this.monthlyDate,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
    );
  }
}

class DateViewModel extends StateNotifier<DateState> {
  DateViewModel() : super(DateState.initial());

  void initDate() {
    state = DateState.initial();
  }

  /// 전체/All 날짜 설정
  void updateAllDate(DateTime date) {
    state = state.copyWith(allDate: date);
  }

  /// 일별/Daily 날짜 설정
  void updateDailyDate(DateTime date) {
    state = state.copyWith(dailyDate: date);
  }

  /// 월별/Monthly 날짜 설정
  void updateMonthlyDate(DateTime date) {
    // year-month 정보만 사용
    state = state.copyWith(monthlyDate: DateTime(date.year, date.month));
  }

  /// 기간/Period 설정
  void selectRange(DateTime start, DateTime end) {
    state = state.copyWith(periodStart: start, periodEnd: end);
  }

  /// 기간 초기화
  void clearRange() {
    state = state.copyWith(periodStart: null, periodEnd: null);
  }
}

final dateViewModel = StateNotifierProvider<DateViewModel, DateState>((ref) {
  return DateViewModel();
});
