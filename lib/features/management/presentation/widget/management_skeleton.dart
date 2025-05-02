// lib/features/management/presentation/widget/management_skeleton.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 관리 화면의 로딩 스켈레톤
class ManagementSkeleton extends StatelessWidget {
  const ManagementSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int rowCount = 10;
    const int columnCount = 5;

    Widget shimmerBox({double? width, double height = 16.0}) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          color: Colors.grey.shade300,
        ),
      );
    }

    final availableHeight = MediaQuery.of(context).size.height * 0.7;

    return SizedBox(
      height: availableHeight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(width: 200, height: 24),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: rowCount,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Row(
                    children: List.generate(columnCount, (_) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: shimmerBox(height: 20),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
