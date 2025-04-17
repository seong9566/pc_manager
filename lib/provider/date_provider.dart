import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateState {
  DateTime selectDate;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  DateState({
    required this.selectDate,
    this.periodStart,
    this.periodEnd,
  });

  DateState copyWith({
    DateTime? selectDate,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    return DateState(
      selectDate: selectDate ?? this.selectDate,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return selectDate.year == now.year &&
        selectDate.month == now.month &&
        selectDate.day == now.day;
  }
}

class DateViewModel extends StateNotifier<DateState> {
  DateViewModel()
      : super(
          DateState(
            selectDate: DateTime.now(),
            periodStart: DateTime.now(),
            periodEnd: DateTime.now().add(const Duration(days: 1)),
          ),
        );

  /// 날짜 업데이트
  void update(DateTime newDate) {
    state = state.copyWith(
      selectDate: newDate,
    );
  }

  /// 기간 선택
  void selectRange(DateTime start, DateTime end) {
    state = state.copyWith(periodStart: start, periodEnd: end);
  }

  /// 기간 초기화
  void clearRange() {
    state = state.copyWith(periodStart: null, periodEnd: null);
  }

  /// 날짜 선택
  void selectedDate(DateTime selectDate) {
    update(selectDate);
  }
}

final dateViewModel = StateNotifierProvider<DateViewModel, DateState>((ref) {
  return DateViewModel();
});
