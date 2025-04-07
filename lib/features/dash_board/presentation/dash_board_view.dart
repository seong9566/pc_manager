import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/dash_board/presentation/widget/dash_board_body.dart';
import 'package:ip_manager/features/dash_board/presentation/widget/dash_board_header.dart';

class DashBoardView extends ConsumerStatefulWidget {
  const DashBoardView({super.key});

  @override
  ConsumerState<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends ConsumerState<DashBoardView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: Responsive.isDesktop(context) ? 120 : 20),
          // TextButton(
          //   onPressed: () {
          //     ref.read(dashBoardViewModelProvider.notifier).getDashBoardData();
          //   },
          //   child: Text("Api TestButton "),
          // ),

          /// Header
          DashBoardHeader(),
          SizedBox(height: 40),
          if (Responsive.isDesktop(context)) DashBoardBody(),
        ],
      ),
    );
  }
}
