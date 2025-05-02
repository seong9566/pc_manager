import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'management_body.dart';

/// 관리 화면의 로딩 스켈레톤
class ManagementSkeleton extends StatelessWidget {
  const ManagementSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const rowCount = 6;
    final widths = [
      nameWidth,
      addressWidth,
      ipWidth,
      portWidth,
      seatWidth,
      priceWidth,
      specificationWidth,
      agencyWidth,
      memoWidth,
      actionWidth,
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          SizedBox(
            width: 200,
            height: 24,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 16),
          // Content skeleton wrapped in horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row skeleton
                Row(
                  children: [
                    for (int i = 0; i < widths.length; i++) ...[
                      Container(
                        width: widths[i],
                        height: 16,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.grey.shade300),
                        ),
                      ),
                      if (i < widths.length - 1) const SizedBox(width: 12),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                // Data rows skeleton
                for (int r = 0; r < rowCount; r++) ...[
                  Row(
                    children: [
                      for (int i = 0; i < widths.length; i++) ...[
                        Container(
                          width: widths[i],
                          height: 16,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(color: Colors.grey.shade300),
                          ),
                        ),
                        if (i < widths.length - 1) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  if (r < rowCount - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
