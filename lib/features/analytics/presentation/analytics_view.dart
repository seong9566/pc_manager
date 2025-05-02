// lib/features/analytics/presentation/analytics_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/provider/date_provider.dart';

import '../../../core/config/screen_size.dart';
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

  void _onTypeChanged(AnalyticsType newType) {
    // 1) 로컬 상태 업데이트
    setState(() => currentType = newType);

    // 2) 탭에 맞는 API 호출
    final vm = ref.read(analyticsViewModelProvider.notifier);
    final dateState = ref.read(dateViewModel);
    switch (newType) {
      case AnalyticsType.all:
        vm.getThisDayDataList(
          targetDate: dateState.allDate,
        );
        break;
      case AnalyticsType.daily:
        vm.getDaysDataList(
          targetDate: dateState.dailyDate,
        );
        break;
      case AnalyticsType.monthly:
        vm.getMonthDataList(
          targetDate: dateState.monthlyDate,
        );
        break;
      case AnalyticsType.period:
        if (dateState.periodStart != null && dateState.periodEnd != null) {
          vm.getPeriodDataList(
            startDate: dateState.periodStart!,
            endDate: dateState.periodEnd!,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateState = ref.watch(dateViewModel);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Responsive.isDesktop(context) ? 40 : 20),

          // 1) 검색창 + 드롭다운
          AnalyticsHeader(
            onSearch: (pcName) {
              ref
                  .read(analyticsViewModelProvider.notifier)
                  .searchPcName(pcName);
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
          Expanded(
            child: AnalyticsBody(
              currentType: currentType,
              onTypeChanged: _onTypeChanged,
            ),
          ),
          // AnalyticsBody(
          //   currentType: currentType,
          //   onTypeChanged: (newType) => setState(() => currentType = newType),
          // ),
        ],
      ),
    );
  }
}
