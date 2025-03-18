import 'package:flutter/material.dart';

class DashBoardHeader extends StatelessWidget {
  const DashBoardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _headerItem('매출 1위 상권', Icons.leaderboard, '동네 (3rd Layer)'),
        _headerItem('매출 1위 매장', Icons.emoji_events, '매장 이름 '),
        _headerItem('가동률 1위 매장', Icons.auto_graph, '매장 이름 '),
      ],
    );
  }

  Widget _headerItem(String title, IconData icon, String subTitle) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
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
      ),
    );
  }
}
