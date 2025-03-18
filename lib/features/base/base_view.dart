import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/base/widget/side_menu.dart';
import 'package:ip_manager/features/dash_board/dash_board_view.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int selectedIndex = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    pages = [DashBoardView()];
    super.initState();
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(selectedIndex: selectedIndex, onTap: _onItemTapped),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: Row(
            children: [
              /// Body
              if (Responsive.isDesktop(context))
                Expanded(
                  // 2/9 = 0.22 , 22%의 공간을 차지.
                  flex: 2, // 전체 공간의 2
                  child: SideMenu(
                    selectedIndex: selectedIndex,
                    onTap: _onItemTapped,
                  ),
                ),
              Expanded(
                flex: 8, // 전체 공간의 7
                child: IndexedStack(index: selectedIndex, children: [...pages]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
