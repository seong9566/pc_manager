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

  @override
  Widget build(BuildContext context) {
    final dateState = ref.watch(dateViewModel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // 1) 검색창 + 드롭다운
        AnalyticsHeader(
          onSearch: (pcName) {
            ref.read(analyticsViewModelProvider.notifier).searchPcName(pcName);
          },
          onCountryChanged: (countryId) {
            ref.read(analyticsViewModelProvider.notifier).changeCountry(
                  countryId,
                  dateState.allDate,
                  dateState.dailyDate,
                  dateState.monthlyDate,
                  dateState.periodStart,
                  dateState.periodEnd,
                );
          },
        ),

        // 2) 탭 버튼들 + 날짜 선택
        AnalyticsBody(
          currentType: currentType,
          onTypeChanged: (newType) => setState(() => currentType = newType),
        ),
      ],
    );
  }
}
