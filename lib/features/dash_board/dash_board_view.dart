import 'package:flutter/material.dart';
import 'package:ip_manager/features/dash_board/widget/dash_board_body.dart';
import 'package:ip_manager/features/dash_board/widget/dash_board_header.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 120),

        /// Header
        DashBoardHeader(),
        SizedBox(height: 40),
        DashBoardBody(),
      ],
    );
  }
}
