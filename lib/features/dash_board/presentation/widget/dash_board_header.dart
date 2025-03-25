import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/core/config/screen_size.dart';

class DashBoardHeader extends StatelessWidget {
  const DashBoardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? Row(
          children: [
            Expanded(
              child: _headerItem(
                context,
                '매출 1위 상권',
                Icons.monitor,
                '동네 (3rd Layer)',
              ),
            ),
            Expanded(
              child: _headerItem(
                context,
                '매출 1위 매장',
                Icons.auto_graph,
                '매장 이름 ',
              ),
            ),
            Expanded(
              child: _headerItem(
                context,
                '가동률 1위 매장',
                CupertinoIcons.timer,
                '매장 이름 ',
              ),
            ),
          ],
        )
        : Column(
          children: [
            _headerItem(context, '매출 1위 상권', Icons.monitor, '동네 (3rd Layer)'),
            SizedBox(height: 24),
            _headerItem(context, '매출 1위 매장', Icons.auto_graph, '매장 이름 '),
            SizedBox(height: 24),
            _headerItem(context, '가동률 1위 매장', CupertinoIcons.timer, '매장 이름 '),
          ],
        );
  }

  Widget _headerItem(
    BuildContext context,
    String title,
    IconData icon,
    String subTitle,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Icon(icon),
            ],
          ),
          SizedBox(height: 20),

          /// SubTitle
          Text(subTitle, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
