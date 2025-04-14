import 'package:flutter/material.dart';
import 'package:ip_manager/features/analytics/presentation/widget/analytics_body.dart';
import 'package:ip_manager/features/analytics/presentation/widget/analytics_header.dart';

import '../../../core/config/app_theme.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [AppTheme.greyShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          AnalyticsHeader(),
          AnalyticsBody(),
        ],
      ),
    );
  }
}
