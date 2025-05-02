// lib/features/dash_board/presentation/dash_board_body_skeleton.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ip_manager/core/config/screen_size.dart';

/// DashBoardBody와 동일한 레이아웃의 스켈레톤 위젯
class DashBoardBodySkeleton extends StatelessWidget {
  const DashBoardBodySkeleton({Key? key}) : super(key: key);

  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _cardRadius = 12.0;
  static const double _cardElevation = 8.0;
  static const double _cardSpacing = 16.0;
  static const int _rowCount = 4; // 테이블 행 개수
  static const double _tableHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: LayoutBuilder(builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        if (isDesktop) {
          final cardWidth = (totalWidth - _cardSpacing) / 2;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(cardWidth),
              SizedBox(width: _cardSpacing),
              _buildCard(cardWidth),
            ],
          );
        } else {
          final cardWidth = totalWidth;
          return Column(
            children: [
              _buildCard(cardWidth),
              SizedBox(height: _cardSpacing),
              _buildCard(cardWidth),
            ],
          );
        }
      }),
    );
  }

  Widget _buildCard(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(_horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: _cardElevation,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 스켈레톤
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: width * 0.5,
              height: 24,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 12),
          // 테이블 스켈레톤 (3열)
          SizedBox(
            height: _tableHeight,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                children: List.generate(_rowCount, (_) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: List.generate(3, (i) {
                        return Container(
                          width: (width -
                                  _horizontalPadding * 2 -
                                  (_cardSpacing * (3 - 1))) /
                              3,
                          height: 14,
                          margin:
                              EdgeInsets.only(right: i < 2 ? _cardSpacing : 0),
                          color: Colors.grey.shade300,
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
