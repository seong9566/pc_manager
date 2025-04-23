// lib/features/analytics/presentation/analytics_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/provider/date_provider.dart';

import 'widget/analytics_header.dart';
import 'widget/analytics_body.dart';

class AnalyticsView extends ConsumerStatefulWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  ConsumerState<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends ConsumerState<AnalyticsView> {
  late AnalyticsType currentType;

  @override
  void initState() {
    super.initState();
    currentType = AnalyticsType.all;
  }

  /// PC 이름 검색 콜백
  void _onSearch(String pcName) {
    final vm = ref.read(analyticsViewModelProvider.notifier);
    final dateState = ref.read(dateViewModel);

    switch (currentType) {
      case AnalyticsType.all:
        vm.getThisDayDataList(
          targetDate: dateState.allDate,
          pcName: pcName,
        );
        break;
      case AnalyticsType.daily:
        vm.getDaysDataList(
          targetDate: dateState.dailyDate,
          pcName: pcName,
        );
        break;
      case AnalyticsType.monthly:
        final monthDate = dateState.monthlyDate;
        vm.getMonthDataList(
          targetDate: monthDate,
          pcName: pcName,
        );
        break;
      case AnalyticsType.period:
        final start = dateState.periodStart;
        final end = dateState.periodEnd;
        if (start != null && end != null) {
          vm.getPeriodDataList(
            startDate: start,
            endDate: end,
            pcName: pcName,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // 1) 검색창 + 드롭다운
        AnalyticsHeader(onSearch: _onSearch),

        // 2) 탭 버튼들 + 날짜 선택
        AnalyticsBody(
          currentType: currentType,
          onTypeChanged: (newType) => setState(() => currentType = newType),
        ),
      ],
    );
  }
}
