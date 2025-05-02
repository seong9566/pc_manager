import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/dash_board/presentation/dash_board_viewmodel.dart';
import 'package:ip_manager/model/top_analyze_model.dart';

import '../../../../core/config/app_colors.dart';
import 'dash_board_header_skeleton.dart';

class DashBoardHeader extends ConsumerStatefulWidget {
  const DashBoardHeader({super.key});

  @override
  ConsumerState<DashBoardHeader> createState() => _DashBoardHeaderState();
}

class _DashBoardHeaderState extends ConsumerState<DashBoardHeader> {
  @override
  Widget build(BuildContext context) {
    final analyzeModel = ref.watch(dashBoardViewModelProvider).topAnalyzeModel;
    if (analyzeModel == null) {
      return const DashBoardHeaderSkeleton();
    }
    return Responsive.isDesktop(context)
        ? _deskTopHeader(context, analyzeModel)
        : _mobileHeader(context, analyzeModel);
  }

  Column _mobileHeader(BuildContext context, TopAnalyzeModel analyzeModel) {
    return Column(
      children: [
        _headerItem(
          context,
          title: '매출 1위 상권',
          icon: Icons.monitor,
          subTitle: analyzeModel.topSalesStoreName,
        ),
        SizedBox(height: 24),
        _headerItem(
          context,
          title: '매출 1위 매장',
          icon: Icons.auto_graph,
          subTitle: analyzeModel.topUsedRateStoreName,
        ),
        SizedBox(height: 24),
        _headerItem(
          context,
          title: '가동률 1위 매장',
          icon: CupertinoIcons.timer,
          subTitle: analyzeModel.topSalesTownName,
        ),
      ],
    );
  }

  Row _deskTopHeader(BuildContext context, TopAnalyzeModel analyzeModel) {
    return Row(
      children: [
        Expanded(
          child: _headerItem(
            context,
            title: '매출 1위 상권',
            icon: Icons.monitor,
            subTitle: analyzeModel.topSalesStoreName,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _headerItem(
            context,
            title: '매출 1위 매장',
            icon: Icons.auto_graph,
            subTitle: analyzeModel.topUsedRateStoreName,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _headerItem(
            context,
            title: '가동률 1위 매장',
            icon: CupertinoIcons.timer,
            subTitle: analyzeModel.topSalesTownName,
          ),
        ),
      ],
    );
  }

  Widget _headerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String subTitle,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 40, right: 40),
      height: Responsive.isDesktop(context) ? 200 : 160,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppTheme.greyShadow],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainTextColor),
              ),
              Icon(icon),
            ],
          ),
          SizedBox(height: 20),

          /// SubTitle
          Text(subTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }
}
