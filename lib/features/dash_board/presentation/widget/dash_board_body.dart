import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            }),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildScrollableTable(
            title: '분석중인 매장들',
            headers: ['이름', '주소', 'IP', '포트'],
            columnWidths: const [160.0, 250.0, 200.0, 100.0, 48],
            rows: storeState
                .map((e) => [e.name!, e.addr!, e.ip!, e.port.toString()])
                .toList(),
          ),
        ),
        Expanded(
          child: _buildScrollableTable(
            title: '최근 분석결과',
            headers: ['매장 이름', '가동률'],
            columnWidths: const [180.0, 200.0, 100.0, 160.0, 250.0, 48],
            rows: state.data.datas
                .map((e) => [e.pcRoomName, e.returnRate])
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableTable({
    required String title,
    required List<String> headers,
    required List<double> columnWidths,
    required List<List<String>> rows,
  }) {
    final double totalWidth = columnWidths.reduce((a, b) => a + b);

    const headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    final cellStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카드 상단 제목
            Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 가로 스크롤 + 고정 높이 박스
            SizedBox(
              height: 380, // 원하는 높이
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: Column(
                    children: [
                      // ─── 헤더 고정 ─────────────────────
                      Row(
                        children: List.generate(headers.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: SizedBox(
                              width: columnWidths[i],
                              child: Text(
                                headers[i],
                                style: headerStyle,
                              ),
                            ),
                          );
                        }),
                      ),
                      const Divider(height: 1, color: Colors.grey),

                      // ─── 내용 부분만 스크롤 ─────────────────────
                      Expanded(
                        child: ListView.separated(
                          itemCount: rows.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, color: Colors.grey),
                          itemBuilder: (context, rowIndex) {
                            final cells = rows[rowIndex];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: List.generate(cells.length, (i) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: SizedBox(
                                      width: columnWidths[i],
                                      child: Text(
                                        cells[i],
                                        style: cellStyle,
                                      ),
                                    ),
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
      ),
    );
  }
}
