// lib/features/dash_board/presentation/widget/dash_board_header_skeleton.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/core/config/app_theme.dart';

class DashBoardHeaderSkeleton extends StatelessWidget {
  const DashBoardHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? _desktopSkeleton(context)
        : _mobileSkeleton(context);
  }

  Widget _mobileSkeleton(BuildContext context) {
    return Column(
      children: [
        _cardSkeleton(context),
        const SizedBox(height: 24),
        _cardSkeleton(context),
        const SizedBox(height: 24),
        _cardSkeleton(context),
      ],
    );
  }

  Widget _desktopSkeleton(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _cardSkeleton(context)),
        const SizedBox(width: 16),
        Expanded(child: _cardSkeleton(context)),
        const SizedBox(width: 16),
        Expanded(child: _cardSkeleton(context)),
      ],
    );
  }

  Widget _cardSkeleton(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final height = isDesktop ? 200.0 : 160.0;
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [AppTheme.greyShadow],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 24,
                  color: Colors.grey.shade300,
                ),
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // subtitle
            Container(
              width: 100,
              height: 20,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
