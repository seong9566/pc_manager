import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/core/extension/date_time_extension.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/features/analytics/presentation/widget/selected_scroll_table.dart';
import 'package:ip_manager/provider/date_provider.dart';
import 'package:ip_manager/widgets/dot_dialog.dart';

import 'all_scroll_table.dart';

class AnalyticsBody extends ConsumerStatefulWidget {
  const AnalyticsBody({super.key});

  @override
  ConsumerState<AnalyticsBody> createState() => _AnalyticsBodyState();
}

class _AnalyticsBodyState extends ConsumerState<AnalyticsBody> {
  late AnalyticsType currentType;

  @override
  void initState() {
    currentType = AnalyticsType.all;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final periodTableData = ref.watch(analyticsViewModelProvider).periodData;
    final monthTableData = ref.watch(analyticsViewModelProvider).monthData;
    final daysDataTableData = ref.watch(analyticsViewModelProvider).daysData;
    final selectDate = ref.watch(dateViewModel).selectDate;
    Widget table;

    /// All 빼고는 Data만 다르게 넣기
    if (currentType == AnalyticsType.all) {
      table = AllTableScreen();
    } else if (currentType == AnalyticsType.period) {
      table = KeyedSubtree(
        key: ValueKey('period-${periodTableData.hashCode}'),
        child: SelectedScrollTable(tableData: periodTableData),
      );
    } else if (currentType == AnalyticsType.monthly) {
      table = KeyedSubtree(
        key: ValueKey('monthly-${monthTableData.hashCode}'),
        child: SelectedScrollTable(tableData: monthTableData),
      );
    } else if (currentType == AnalyticsType.daily) {
      table = KeyedSubtree(
        key: ValueKey('daily-${daysDataTableData.hashCode}'),
        child: SelectedScrollTable(tableData: daysDataTableData),
      );
    } else {
      table = AllTableScreen();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rowButtons(selectDate),
        SizedBox(height: 20),
        SizedBox(height: 400, child: table),
      ],
    );
  }

  Widget _rowButtons(DateTime selectDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buttonItem('전체 분석 기록', () {
          setState(() {
            currentType = AnalyticsType.all;
          });
        }, AnalyticsType.all),
        SizedBox(width: 24),
        _buttonItem('기간별 기록', () {
          setState(() {
            currentType = AnalyticsType.period;
          });
        }, AnalyticsType.period),
        SizedBox(width: 24),
        _buttonItem('월별 기록', () {
          setState(() {
            currentType = AnalyticsType.monthly;
          });
        }, AnalyticsType.monthly),
        SizedBox(width: 24),
        _buttonItem('일별 기록', () {
          setState(() {
            currentType = AnalyticsType.daily;
          });
        }, AnalyticsType.daily),
        Spacer(),

        /// DatePicker : Default : 현재 날짜
        _datePicker(),
      ],
    );
  }

  Widget _datePicker() {
    final dateState = ref.watch(dateViewModel);
    final selectDate = dateState.selectDate;
    final periodStart = dateState.periodStart;
    final periodEnd = dateState.periodEnd;
    String label;
    switch (currentType) {
      case AnalyticsType.period:
        if (periodStart != null && periodEnd != null) {
          label =
              '${periodStart.toDateOnlyForString()} ~ ${periodEnd.toDateOnlyForString()}';
        } else {
          label = '기간 선택';
        }
        break;
      case AnalyticsType.monthly:
        label =
            '${selectDate.year}-${selectDate.month.toString().padLeft(2, '0')}';
        break;
      case AnalyticsType.daily:
      case AnalyticsType.all:
        label = selectDate.toDateOnlyForString();
    }

    return GestureDetector(
      onTap: () {
        final dateState = ref.read(dateViewModel);
        showAnalyticsDatePicker(
          context: context,
          ref: ref,
          type: currentType,
          periodStart: dateState.periodStart,
          periodEnd: dateState.periodEnd,
          onDaySelected: (date) {
            ref.read(dateViewModel.notifier).selectedDate(date);
          },
          onRangeSelected: (start, end) {
            ref.read(dateViewModel.notifier).selectRange(start, end);
          },
          onMonthSelected: (monthDate) {
            ref.read(dateViewModel.notifier).selectedDate(monthDate);
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.purpleColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          '선택된 날짜 : $label',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buttonItem(String title, VoidCallback onTap, AnalyticsType type) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: currentType == type ? FontWeight.bold : FontWeight.normal,
          color: currentType == type ? AppColors.purpleColor : Colors.grey,
        ),
      ),
    );
  }
}

enum AnalyticsType {
  all, // 전체 분석기록
  period, // 기간별 분석
  monthly, // 월별 분석
  daily, // 일별 분석
}
