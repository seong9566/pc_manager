import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/core/database/prefs.dart';
import 'package:ip_manager/features/auth/presentation/login_view.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';

import '../../../../provider/user_session.dart';

class SideMenu extends ConsumerStatefulWidget {
  final Function(int index) onTap;
  final int selectedIndex;
  final String? role;

  const SideMenu(
      {super.key,
      required this.onTap,
      required this.selectedIndex,
      required this.role});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.only(top: 20, left: 24, right: 20)
                    : EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    if (Responsive.isDesktop(context)) _title(),
                    SizedBox(height: 80),
                    _drawerItem(0, '대시 보드', Icons.dashboard),
                    SizedBox(height: 20),
                    _drawerItem(1, '매장 관리', Icons.store),
                    SizedBox(height: 20),
                    _drawerItem(2, '매장 분석 기록', Icons.analytics),
                  ],
                ),
              ),
            ),
            if (widget.role == "Master")
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(tabIndexProvider.notifier).select(4); // 이동
                      },
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset("assets/icon/setting.png")),
                    ),
                    // 로그아웃 버튼
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () async {
                        // 세션 클리어
                        ref.read(userSessionProvider.notifier).clearSession();
                        await Prefs().clear();
                        // 로그인 페이지로 이동
                        context.goNamed('login');
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 20,
                        color: Colors.black87,
                      ),
                      label: const Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // TextButton(
                    //     onPressed: () async {
                    //       /// 안해주면 리다이렉션에 걸림
                    //       ref.read(userSessionProvider.notifier).clearSession();
                    //       await Prefs().clear().then((_) {
                    //         context.pushNamed('login');
                    //       });
                    //     },
                    //     child: Text(
                    //       "로그아웃",
                    //       style: TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.black),
                    //     )),
                  ],
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(int index, String title, IconData icon) {
    final bool isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.purpleColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.isDesktop(context) ? 18 : 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.purpleColor : Colors.black,
              ),
            ),
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.purpleColor : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'Pc Manager-Analyzer',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
