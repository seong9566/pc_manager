import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../features/analytics/presentation/widget/analytics_body.dart';
import '../provider/date_provider.dart';

Future<void> showAnalyticsDatePicker({
  required BuildContext context,
  required WidgetRef ref,
  required AnalyticsType type,
  DateTime? periodStart,
  DateTime? periodEnd,
  required void Function(DateTime) onDaySelected,
  required void Function(DateTime, DateTime) onRangeSelected,
  required void Function(DateTime) onMonthSelected,
}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: SizedBox(
        width: 300,
        height: type == AnalyticsType.monthly ? 350 : 400,
        child: SfDateRangePicker(
          showActionButtons: true,
          confirmText: '확인',
          cancelText: '닫기',
          onCancel: () => Navigator.pop(context),
          onSubmit: (args) {
            switch (type) {
              case AnalyticsType.monthly:
                final dt = args as DateTime;
                onMonthSelected(DateTime(dt.year, dt.month));
                break;
              case AnalyticsType.period:
                final range = args as PickerDateRange;
                if (range.startDate != null && range.endDate != null) {
                  onRangeSelected(range.startDate!, range.endDate!);
                }
                break;
              case AnalyticsType.daily:
              case AnalyticsType.all:
                final date = args as DateTime;
                onDaySelected(date);
                break;
            }
            Navigator.pop(context);
          },
          allowViewNavigation: type != AnalyticsType.monthly,
          view: type == AnalyticsType.monthly
              ? DateRangePickerView.year
              : DateRangePickerView.month,
          selectionMode: type == AnalyticsType.period
              ? DateRangePickerSelectionMode.range
              : DateRangePickerSelectionMode.single,
          initialSelectedDate: ref.read(dateViewModel).selectDate,
          initialSelectedRange: (periodStart != null && periodEnd != null)
              ? PickerDateRange(periodStart, periodEnd)
              : null,
        ),
      ),
    ),
  );
}
