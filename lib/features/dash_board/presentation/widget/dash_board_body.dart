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
            Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: totalWidth + 24,
              height: 380,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: ListView.builder(
                    itemCount: rows.length + 1,
                    itemBuilder: (context, index) {
                      final isHeader = index == 0;
                      final cells = isHeader ? headers : rows[index - 1];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: List.generate(cells.length, (i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: SizedBox(
                                    width: columnWidths[i],
                                    child: Text(
                                      cells[i],
                                      style: TextStyle(
                                        fontSize: isHeader ? 18 : 14,
                                        fontWeight: isHeader
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isHeader
                                            ? Colors.black
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
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
