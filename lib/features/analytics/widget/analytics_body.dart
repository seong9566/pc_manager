import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/features/analytics/widget/selected_scroll_table.dart';

import 'all_scroll_table.dart';

class AnalyticsBody extends StatefulWidget {
  const AnalyticsBody({super.key});

  @override
  State<AnalyticsBody> createState() => _AnalyticsBodyState();
}

class _AnalyticsBodyState extends State<AnalyticsBody> {
  late AnalyticsType currentType;

  @override
  void initState() {
    currentType = AnalyticsType.all;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget table;

    /// All 빼고는 Data만 다르게 넣기
    if (currentType == AnalyticsType.all) {
      table = AllTableScreen();
    } else if (currentType == AnalyticsType.period) {
      table = SelectedScrollTable();
    } else if (currentType == AnalyticsType.monthly) {
      table = SelectedScrollTable();
    } else if (currentType == AnalyticsType.daily) {
      table = SelectedScrollTable();
    } else {
      table = AllTableScreen();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rowButtons(),
        SizedBox(height: 20),
        SizedBox(height: 640, child: table),
      ],
    );
  }

  Widget _rowButtons() {
    return Row(
      children: [
        _buttonItem('전체 분석 기록', () {
          setState(() {
            currentType = AnalyticsType.all;
          });
        }, AnalyticsType.all),
        SizedBox(width: 12),
        _buttonItem('기간별 기록', () {
          setState(() {
            currentType = AnalyticsType.period;
          });
        }, AnalyticsType.period),
        SizedBox(width: 12),
        _buttonItem('월별 기록', () {
          setState(() {
            currentType = AnalyticsType.monthly;
          });
        }, AnalyticsType.monthly),
        SizedBox(width: 12),
        _buttonItem('일별 기록', () {
          setState(() {
            currentType = AnalyticsType.daily;
          });
        }, AnalyticsType.daily),
        SizedBox(width: 12),

        /// DatePicker : Default : 현재 날짜
        _datePicker("2025-03-17", () {
          debugPrint("[Flutter] >> DatePicker Click!");
        }),
      ],
    );
  }

  Widget _datePicker(String date, Function onTap) {
    return GestureDetector(
      onTap: onTap(),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.black,
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
