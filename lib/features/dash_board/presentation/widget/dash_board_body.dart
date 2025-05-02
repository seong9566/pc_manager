import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/widgets/default_button.dart';

import '../dash_board_viewmodel.dart';

class DashBoardBody extends ConsumerWidget {
  const DashBoardBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashBoardViewModelProvider).dashBoardModel;
    final storeState = ref.watch(managementViewModelProvider).value;

    if (state == null || storeState == null) {
      return Center(
        child: SizedBox(
          width: 200,
          child: DefaultButton(
            text: '새로 고침',
            callback: () {
              ref.read(dashBoardViewModelProvider.notifier).getDashBoardData();
            },
          ),
        ),
      );
    }

    // ─── 데스크탑 레이아웃 ─────────────────────
    if (Responsive.isDesktop(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildScrollableTable(
              title: '분석중인 매장들',
              headers: ['이름', '주소', 'IP', '포트'],
              columnWidths: const [160.0, 250.0, 180.0, 100.0],
              rows: storeState
                  .map((e) => [e.name!, e.addr!, e.ip!, e.port.toString()])
                  .toList(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildScrollableTable(
              title: '최근 분석결과',
              headers: ['매장 이름', '가동률'],
              columnWidths: const [180.0, 200.0, 80.0],
              rows: state.data.datas
                  .map((e) => [e.pcRoomName, e.returnRate])
                  .toList(),
            ),
          ),
        ],
      );
    }

    // ─── 모바일 레이아웃 ─────────────────────
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildScrollableTable(
            title: '분석중인 매장들',
            headers: ['이름', '주소', 'IP', '포트'],
            columnWidths: const [160, 250, 200, 100],
            rows: storeState
                .map((e) => [e.name!, e.addr!, e.ip!, e.port.toString()])
                .toList(),
          ),
          const SizedBox(height: 24),
          _buildScrollableTable(
            title: '최근 분석결과',
            headers: ['매장 이름', '가동률'],
            columnWidths: const [160, 250, 200, 100],
            rows: state.data.datas
                .map((e) => [e.pcRoomName, e.returnRate])
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableTable({
    required String title,
    required List<String> headers,
    required List<double> columnWidths,
    required List<List<String>> rows,
  }) {
    final totalWidth = columnWidths.reduce((a, b) => a + b);
    const headerStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black);
    final cellStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // 고정 높이 박스 안에서만 스크롤
          SizedBox(
            height: 300, // 원하는 높이
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth,
                child: Column(
                  children: [
                    // 헤더
                    Row(
                      children: List.generate(headers.length, (i) {
                        return SizedBox(
                          width: columnWidths[i],
                          child: Text(headers[i], style: headerStyle),
                        );
                      }),
                    ),
                    const Divider(color: Colors.grey),

                    // 내용
                    Expanded(
                      child: ListView.separated(
                        itemCount: rows.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.grey),
                        itemBuilder: (context, idx) {
                          final cells = rows[idx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: List.generate(cells.length, (i) {
                                return SizedBox(
                                  width: columnWidths[i],
                                  child: Text(cells[i], style: cellStyle),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
