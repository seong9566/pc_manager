import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_view.dart';
import 'package:ip_manager/features/base/presentation/widget/side_menu.dart';
import 'package:ip_manager/features/dash_board/presentation/dash_board_view.dart';
import 'package:ip_manager/features/management/presentation/store_add_view.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';
import 'package:toastification/toastification.dart';

import '../../../model/management_model.dart';
import '../../../provider/user_session.dart';
import '../../account/presentation/account_view.dart';
import '../../management/presentation/management_view.dart';

class BaseView extends ConsumerStatefulWidget {
  const BaseView({super.key});

  @override
  ConsumerState<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends ConsumerState<BaseView> {
  List<Widget> pages = [];

  bool mobileSideMenu = false;
  bool sideMenuOn = true;

  @override
  void initState() {
    pages = [
      DashBoardView(),
      ManagementView(),
      AnalyticsView(),
      StoreAddView(),
      AccountView(),
    ];
    // 화면 렌더링 후 배너 띄우기
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final session = ref.read(userSessionProvider);
      final role = session.role ?? '';
      if (mounted) {
        toastification.show(
          context: context,
          showIcon: false,
          autoCloseDuration: Duration(milliseconds: 2000),
          title: Text(
            "$role님 어서오세요!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.topCenter,
        );
      }
    });
    super.initState();
  }

  void sideMenuTouch() {
    setState(() {
      sideMenuOn = !sideMenuOn;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      ref.read(selectedStoreProvider.notifier).state = ManagementModel.empty();
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
        appBar: !Responsive.isDesktop(context) ? _appBar(selectedIndex) : null,
        // drawer: SideMenu(selectedIndex: selectedIndex, onTap: _onItemTapped),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: Row(
              children: [
                /// Body
                if (Responsive.isDesktop(context) && sideMenuOn)
                  Expanded(
                    // 2/9 = 0.22 , 22%의 공간을 차지.
                    flex: 2, // 전체 공간의 2
                    child: SideMenu(
                      role: ref.watch(userSessionProvider).role ?? '',
                      selectedIndex: selectedIndex,
                      onTap: _onItemTapped,
                    ),
                  ),
                Expanded(
                  flex: 8,
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

  AppBar _appBar(int selectedIndex) {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: MediaQuery.sizeOf(context).width * 0.7,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Pc Manager-Analyzer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xff6E79A5),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: "SideMenu",
                pageBuilder: (_, __, ___) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: double.infinity,
                      color: Colors.white,
                      child: SideMenu(
                        role: ref.watch(userSessionProvider).role ?? '',
                        selectedIndex: selectedIndex,
                        onTap: (index) {
                          Navigator.pop(context); // 닫기
                          _onItemTapped(index); // 이동
                        },
                      ),
                    ),
                  );
                },
                transitionBuilder: (_, anim, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(1, 0), // 오른쪽에서 시작
                      end: Offset(0, 0),
                    ).animate(anim),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 150),
              );
            },
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
