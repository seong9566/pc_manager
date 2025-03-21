import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/analytics/analytics_view.dart';
import 'package:ip_manager/features/base/presentation/widget/side_menu.dart';
import 'package:ip_manager/features/dash_board/dash_board_view.dart';
import 'package:ip_manager/features/store_add/presentation/store_add_view.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';

import '../../management/presentation/management_view.dart';

class BaseView extends ConsumerStatefulWidget {
  const BaseView({super.key});

  @override
  ConsumerState<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends ConsumerState<BaseView> {
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      DashBoardView(),
      ManagementView(),
      AnalyticsView(),
      StoreAddView(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      ref.read(baseViewIndexProvider.notifier).state = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(baseViewIndexProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
        if (canPop) {
          debugPrint("[Flutter] >> 뒤로가기 방지");
          return;
        }
      },
      child: Scaffold(
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
                  child: IndexedStack(
                    index: selectedIndex,
                    children: [...pages],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
