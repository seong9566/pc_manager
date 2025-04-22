// lib/features/analytics/presentation/widget/analytics_body.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/core/extension/date_time_extension.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/features/analytics/presentation/widget/selected_scroll_table.dart';
import 'package:ip_manager/features/analytics/presentation/widget/all_scroll_table.dart';
import 'package:ip_manager/provider/date_provider.dart';
import 'package:ip_manager/widgets/dot_dialog.dart';

class AnalyticsBody extends ConsumerStatefulWidget {
  final AnalyticsType currentType;
  final void Function(AnalyticsType) onTypeChanged;

  const AnalyticsBody({
    Key? key,
    required this.currentType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  ConsumerState<AnalyticsBody> createState() => _AnalyticsBodyState();
}

class _AnalyticsBodyState extends ConsumerState<AnalyticsBody> {
  void _showDatePicker() {
    final dateState = ref.read(dateViewModel);
    showAnalyticsDatePicker(
      context: context,
      ref: ref,
      type: widget.currentType,
      periodStart: dateState.periodStart,
      periodEnd: dateState.periodEnd,
      onDaySelected: (date) {
        // 1) 날짜 상태 업데이트
        ref.read(dateViewModel.notifier).selectedDate(date);
        // 2) ViewModel 에 API 호출
        ref
            .read(analyticsViewModelProvider.notifier)
            .getThisDayDataList(targetDate: date);
      },
      onRangeSelected: (start, end) {
        ref.read(dateViewModel.notifier).selectRange(start, end);
        ref
            .read(analyticsViewModelProvider.notifier)
            .getPeriodDataList(startDate: start, endDate: end);
      },
      onMonthSelected: (monthDate) {
        ref.read(dateViewModel.notifier).selectedDate(monthDate);
        ref
            .read(analyticsViewModelProvider.notifier)
            .getMonthDataList(targetDate: monthDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectDate = ref.watch(dateViewModel).selectDate;

    Widget table;
    final vmState = ref.watch(analyticsViewModelProvider);
    switch (widget.currentType) {
      case AnalyticsType.all:
        table = AllTableScreen();
        break;
      case AnalyticsType.period:
        table = KeyedSubtree(
          key: ValueKey(vmState.periodData.length),
          child: SelectedScrollTable(tableData: vmState.periodData),
        );
        break;
      case AnalyticsType.monthly:
        table = KeyedSubtree(
          key: ValueKey(vmState.monthData.length),
          child: SelectedScrollTable(tableData: vmState.monthData),
        );
        break;
      case AnalyticsType.daily:
        table = KeyedSubtree(
          key: ValueKey(vmState.daysData.length),
          child: SelectedScrollTable(tableData: vmState.daysData),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [AppTheme.greyShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowButtons(selectDate),
          const SizedBox(height: 20),
          SizedBox(height: 400, child: table),
        ],
      ),
    );
  }

  Widget _rowButtons(DateTime selectDate) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        return isNarrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: AnalyticsType.values.map((type) {
                      return _buttonItem(
                        _typeLabel(type),
                        () => widget.onTypeChanged(type),
                        type,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Center(child: _datePicker()),
                ],
              )
            : Row(
                children: [
                  for (var type in AnalyticsType.values) ...[
                    _buttonItem(
                      _typeLabel(type),
                      () => widget.onTypeChanged(type),
                      type,
                    ),
                    const SizedBox(width: 24),
                  ],
                  const Spacer(),
                  _datePicker(),
                ],
              );
      },
    );
  }

  String _typeLabel(AnalyticsType type) {
    switch (type) {
      case AnalyticsType.all:
        return '전체 분석 기록';
      case AnalyticsType.period:
        return '기간별 기록';
      case AnalyticsType.monthly:
        return '월별 기록';
      case AnalyticsType.daily:
        return '일별 기록';
    }
  }

  Widget _datePicker() {
    final ds = ref.watch(dateViewModel);
    final sel = ds.selectDate;
    final start = ds.periodStart;
    final end = ds.periodEnd;

    String label;
    switch (widget.currentType) {
      case AnalyticsType.period:
        label = (start != null && end != null)
            ? '${start.toDateOnlyForString()} ~ ${end.toDateOnlyForString()}'
            : '기간 선택';
        break;
      case AnalyticsType.monthly:
        label = '${sel.year}-${sel.month.toString().padLeft(2, '0')}';
        break;
      default:
        label = sel.toDateOnlyForString();
    }

    return ElevatedButton.icon(
      onPressed: _showDatePicker,
      icon: const Icon(Icons.calendar_today, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.purpleColor,
        side: BorderSide(color: AppColors.purpleColor, width: 1.5),
        elevation: 2,
        shadowColor: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buttonItem(String title, VoidCallback onTap, AnalyticsType type) {
    final isSelected = widget.currentType == type;
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.purpleColor : Colors.grey,
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
