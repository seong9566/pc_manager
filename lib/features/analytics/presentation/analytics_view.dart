// lib/features/analytics/presentation/analytics_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/provider/date_provider.dart';

import 'widget/analytics_header.dart';
import 'widget/analytics_body.dart';

class AnalyticsView extends ConsumerStatefulWidget {
  const AnalyticsView({super.key});

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
    {
      ref.read(analyticsViewModelProvider.notifier).searchPcName(pcName);
    }
  }

  void _onCountryChanged(int countryId) async {
    final vm = ref.read(analyticsViewModelProvider.notifier);
    final dateState = ref.read(dateViewModel);

    // 전체 분석 기록
    vm.getThisDayDataList(
      targetDate: dateState.allDate,
      countryTbId: countryId,
    );
    await Future.delayed(Duration(milliseconds: 500));
    // 일별 기록
    vm.getDaysDataList(
      targetDate: dateState.dailyDate,
      countryTbId: countryId,
    );
    await Future.delayed(Duration(milliseconds: 500));

    // 월별 기록
    vm.getMonthDataList(
      targetDate: dateState.monthlyDate,
      countryTbId: countryId,
    );
    await Future.delayed(Duration(milliseconds: 500));

    // 기간별 기록: 시작과 종료가 모두 존재할 때만 호출
    if (dateState.periodStart != null && dateState.periodEnd != null) {
      vm.getPeriodDataList(
        startDate: dateState.periodStart!,
        endDate: dateState.periodEnd!,
        countryTbId: countryId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // 1) 검색창 + 드롭다운
        AnalyticsHeader(
            onSearch: _onSearch, onCountryChanged: _onCountryChanged),

        // 2) 탭 버튼들 + 날짜 선택
        AnalyticsBody(
          currentType: currentType,
          onTypeChanged: (newType) => setState(() => currentType = newType),
        ),
      ],
    );
  }
}
