import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/screen_size.dart';

class SideMenu extends ConsumerStatefulWidget {
  final Function(int index) onTap;
  final int selectedIndex;

  const SideMenu({super.key, required this.onTap, required this.selectedIndex});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    Responsive.isDesktop(context)
                        ? EdgeInsets.only(top: 20, left: 24, right: 80)
                        : EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(int index, String title, IconData icon) {
    bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.blueAccent.shade100
                  : Colors.white, // 선택된 항목만 파란색
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      isSelected ? Colors.white : Colors.black, // 선택된 항목만 흰색 글씨
                ),
              ),
              Icon(
                icon,
                size: 18,
                color:
                    isSelected ? Colors.white : Colors.black, // 선택된 항목만 흰색 아이콘
              ),
            ],
          ),
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
        color: Color(0xff6E79A5),
      ),
    );
  }
}
