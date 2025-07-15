// lib/features/analytics/presentation/widget/analytics_body.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/core/extension/date_time_extension.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/features/analytics/presentation/providers/analytics_filter_providers.dart';
import 'package:ip_manager/features/analytics/presentation/widget/all_scroll_table.dart';
import 'package:ip_manager/features/analytics/presentation/widget/csv_export_dialog.dart';
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
              .getDaysData(targetDate: date);
        } else {
          dateVm.updateAllDate(date);
          ref
              .read(analyticsViewModelProvider.notifier)
              .getThisDayData(targetDate: date);
        }
      },
      onRangeSelected: (start, end) {
        dateVm.selectRange(start, end);
        ref
            .read(analyticsViewModelProvider.notifier)
            .getPeriodData(startDate: start, endDate: end);
      },
      onMonthSelected: (monthDate) {
        dateVm.updateMonthlyDate(monthDate);
        ref
            .read(analyticsViewModelProvider.notifier)
            .getMonthData(targetDate: monthDate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateState = ref.watch(dateViewModel);
    final vmState = ref.watch(analyticsViewModelProvider);

    // 버튼 옆에 표시할 날짜/기간 라벨
    String label;
    int totalCount;
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
        totalCount = vmState.thisDayData.length;
        break;
      case AnalyticsType.period:
        table = KeyedSubtree(
          key: ObjectKey(vmState.periodData),
          child: SelectedScrollTable(tableData: vmState.periodData),
        );
        totalCount = vmState.periodData.length;
        break;
      case AnalyticsType.monthly:
        table = KeyedSubtree(
          key: ObjectKey(vmState.monthData),
          child: SelectedScrollTable(tableData: vmState.monthData),
        );
        totalCount = vmState.monthData.length;
        break;
      case AnalyticsType.daily:
        table = KeyedSubtree(
          key: ObjectKey(vmState.daysData),
          child: SelectedScrollTable(tableData: vmState.daysData),
        );
        totalCount = vmState.daysData.length;
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
          _rowButtons(label, totalCount),
          const SizedBox(height: 20),
          Expanded(
            child: table,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _rowButtons(String dateLabel, int totalCount) {
    return LayoutBuilder(builder: (context, constraints) {
      final dateVm = ref.read(dateViewModel.notifier);
      final analyticsVm = ref.read(analyticsViewModelProvider.notifier);

      final resetBtn = OutlinedButton.icon(
        onPressed: () {
          // 기존 초기화 코드
          dateVm.initDate();
          analyticsVm.searchPcName('');
          analyticsVm.init();

          // 분석 탭 전용 드롭다운 초기화 (국가/도시/동네)
          ref.read(analyticsSelectedCountryProvider.notifier).state = null;
          ref.read(analyticsSelectedCityProvider.notifier).state = null;
          ref.read(analyticsSelectedTownProvider.notifier).state = null;
        },
        icon: const Icon(Icons.refresh, size: 20, color: Colors.redAccent),
        label: Text(
          '날짜 초기화',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.redAccent),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 48), // 검색창과 동일한 높이 설정
          maximumSize: const Size(180, 48),
          side: BorderSide(
              color: Colors.redAccent.withValues(alpha: 0.5), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: Colors.white,
        ),
      );

      // CSV 내보내기 버튼
      final exportCsvBtn = OutlinedButton.icon(
        onPressed: () {
          final analyticsViewModel =
              ref.read(analyticsViewModelProvider.notifier);
          final pcRoomsList = ref.read(analyticsViewModelProvider).thisDayData;
          showDialog(
            context: context,
            builder: (context) => CsvExportDialog(
              pcRooms: pcRoomsList,
              onExport: (selectedPcRoomIds, startDate, endDate) {
                analyticsViewModel.getExcelData(
                  startDate: startDate,
                  endDate: endDate,
                  pcId: selectedPcRoomIds,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        SizedBox(width: 16),
                        Text('CSV 파일 생성 중...'),
                      ],
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );

                // analyticsViewModel
                //     .exportPcRoomDataToCsv(
                //   selectedPcRoomIds: selectedPcRoomIds,
                //   startDate: startDate,
                //   endDate: endDate,
                // )
                //     .then((result) {
                //   if (result.success) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //           content: Text('파일이 저장되었습니다: ${result.filePath}')),
                //     );
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('오류: ${result.message}')),
                //     );
                //   }
                // });
              },
            ),
          );
        },
        icon: const Icon(Icons.download, size: 20, color: Colors.blue),
        label: Text(
          'CSV 내보내기',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.blue),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 48),
          maximumSize: const Size(180, 48),
          side: BorderSide(color: Colors.blue.withValues(alpha: 0.5), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: Colors.white,
        ),
      );

      final dateBtn = ElevatedButton.icon(
        onPressed: _showDatePicker,
        icon: const Icon(
          Icons.calendar_today,
          size: 20,
          color: Colors.black,
        ),
        label: Text(dateLabel,
            style: const TextStyle(fontSize: 16, color: Colors.black)),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 48), // 검색창과 동일한 높이 설정
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      final tabs = AnalyticsType.values.map((type) {
        final selected = widget.currentType == type;
        return GestureDetector(
          onTap: () => widget.onTypeChanged(type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.purpleColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
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

      final isNarrow = !Responsive.isDesktop(context);

      if (isNarrow) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1) 탭 바
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    ...tabs,
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            // 2) 날짜/초기화 버튼을 가로 스크롤 가능하게
            SizedBox(
              height: 60, // 버튼 높이에 맞게
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    dateBtn,
                    const SizedBox(width: 8),
                    resetBtn,
                    const SizedBox(width: 8),
                    exportCsvBtn,
                    const SizedBox(width: 8), // 오른쪽 여유
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text("총 매장 수 : $totalCount",
                style: TextStyle(fontSize: 16, color: AppColors.mainTextColor)),
          ],
        );
      } else {
        // 데스크탑일 땐 기존 Row
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...tabs.expand((w) => [w, const SizedBox(width: 24)]),
                const Spacer(),
                dateBtn,
                const SizedBox(width: 8),
                resetBtn,
                const SizedBox(width: 8),
                exportCsvBtn,
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text("총 매장 수 : $totalCount",
                  style:
                      TextStyle(fontSize: 16, color: AppColors.mainTextColor)),
            ),
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
