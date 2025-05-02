// lib/features/analytics/presentation/widget/analytics_body.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/core/extension/date_time_extension.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/features/analytics/presentation/widget/all_scroll_table.dart';
import 'package:ip_manager/features/analytics/presentation/widget/selected_scroll_table.dart';
import 'package:ip_manager/provider/date_provider.dart';
import 'package:ip_manager/widgets/dot_dialog.dart';

class AnalyticsBody extends ConsumerStatefulWidget {
  final AnalyticsType currentType;
  final void Function(AnalyticsType) onTypeChanged;

  const AnalyticsBody({
    super.key,
    required this.currentType,
    required this.onTypeChanged,
  });

  @override
  ConsumerState<AnalyticsBody> createState() => _AnalyticsBodyState();
}

class _AnalyticsBodyState extends ConsumerState<AnalyticsBody> {
  void _showDatePicker() {
    final dateState = ref.read(dateViewModel);
    final dateVm = ref.read(dateViewModel.notifier);

    showAnalyticsDatePicker(
      context: context,
      ref: ref,
      type: widget.currentType,
      periodStart: dateState.periodStart,
      periodEnd: dateState.periodEnd,
      onDaySelected: (date) {
        if (widget.currentType == AnalyticsType.daily) {
          dateVm.updateDailyDate(date);
          ref
              .read(analyticsViewModelProvider.notifier)
              .getDaysDataList(targetDate: date);
        } else {
          dateVm.updateAllDate(date);
          ref
              .read(analyticsViewModelProvider.notifier)
              .getThisDayDataList(targetDate: date);
        }
      },
      onRangeSelected: (start, end) {
        dateVm.selectRange(start, end);
        ref
            .read(analyticsViewModelProvider.notifier)
            .getPeriodDataList(startDate: start, endDate: end);
      },
      onMonthSelected: (monthDate) {
        dateVm.updateMonthlyDate(monthDate);
        ref
            .read(analyticsViewModelProvider.notifier)
            .getMonthDataList(targetDate: monthDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateState = ref.watch(dateViewModel);
    final vmState = ref.watch(analyticsViewModelProvider);

    // 버튼 옆에 표시할 날짜/기간 라벨
    String label;
    switch (widget.currentType) {
      case AnalyticsType.period:
        if (dateState.periodStart != null && dateState.periodEnd != null) {
          label =
              '${dateState.periodStart!.toDateOnlyForString()} ~ ${dateState.periodEnd!.toDateOnlyForString()}';
        } else {
          label = '기간 선택';
        }
        break;
      case AnalyticsType.monthly:
        final m = dateState.monthlyDate;
        label = '${m.year}-${m.month.toString().padLeft(2, '0')}';
        break;
      case AnalyticsType.daily:
        label = dateState.dailyDate.toDateOnlyForString();
        break;
      case AnalyticsType.all:
        label = dateState.allDate.toDateOnlyForString();
    }

    Widget table;
    switch (widget.currentType) {
      case AnalyticsType.all:
        table = AllTableScreen();
        break;
      case AnalyticsType.period:
        table = KeyedSubtree(
          key: ObjectKey(vmState.periodData),
          child: SelectedScrollTable(tableData: vmState.periodData),
        );
        break;
      case AnalyticsType.monthly:
        table = KeyedSubtree(
          key: ObjectKey(vmState.monthData),
          child: SelectedScrollTable(tableData: vmState.monthData),
        );
        break;
      case AnalyticsType.daily:
        table = KeyedSubtree(
          key: ObjectKey(vmState.daysData),
          child: SelectedScrollTable(tableData: vmState.daysData),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: EdgeInsets.only(top: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [AppTheme.greyShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowButtons(label),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                // 원하는 최소 높이 지정 (화면에 꽉 차도록)
                height: MediaQuery.of(context).size.height * 0.6,
                child: table,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowButtons(String dateLabel) {
    return LayoutBuilder(builder: (context, constraints) {
      // Reset button setup
      final dateVm = ref.read(dateViewModel.notifier);
      final analyticsVm = ref.read(analyticsViewModelProvider.notifier);

      final resetBtn = OutlinedButton.icon(
        onPressed: () {
          dateVm.initDate();
          analyticsVm.searchPcName('');
          analyticsVm.init();
        },
        icon: const Icon(
          Icons.refresh, // 원하는 아이콘으로 바꿔도 됩니다
          size: 20,
          color: AppColors.purpleColor,
        ),
        label: const Text(
          '초기화',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.purpleColor,
          ),
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.purpleColor,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: Colors.white,
          // 배경이 투명/흰색
          foregroundColor: AppColors.purpleColor,
        ),
      );
      final isNarrow = !Responsive.isDesktop(context);

      final tabs = AnalyticsType.values.map((type) {
        final selected = widget.currentType == type;
        return GestureDetector(
          onTap: () => widget.onTypeChanged(type),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.purpleColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Text(
              _typeLabel(type),
              style: TextStyle(
                fontSize: 18,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? AppColors.purpleColor : Colors.grey,
              ),
            ),
          ),
        );
      }).toList();

      final dateBtn = ElevatedButton.icon(
        onPressed: _showDatePicker,
        icon: const Icon(Icons.calendar_today, size: 20),
        label: Text(dateLabel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColors.purpleColor,
            )),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.purpleColor,
          side: BorderSide(color: AppColors.purpleColor, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      if (isNarrow) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1) 가로 스크롤 가능한 탭 바
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    ...tabs.map((tab) => tab),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 2) 날짜선택 + 초기화 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                dateBtn,
                const SizedBox(width: 8),
                resetBtn,
              ],
            ),
          ],
        );
      } else {
        return Row(
          children: [
            ...tabs.expand((w) => [w, const SizedBox(width: 24)]).toList(),
            const Spacer(),
            dateBtn,
            const SizedBox(width: 8),
            resetBtn,
          ],
        );
      }
    });
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
}
