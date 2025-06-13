import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';

import '../../../../model/time_count_model.dart';

class AllTableScreen extends ConsumerStatefulWidget {
  const AllTableScreen({super.key});

  @override
  ConsumerState<AllTableScreen> createState() => _AllTableScreenState();
}

class _AllTableScreenState extends ConsumerState<AllTableScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsViewModelProvider).thisDayData;
    final vmState = ref.watch(analyticsViewModelProvider);

    if (vmState.isLoading) {
      return SizedBox(
        height: 600,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isEmpty) {
      return Center(
        child: Text(
          '데이터가 없습니다. 새로고침 또는 다른 날을 선택해 주세요.',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );
    }

    /// ExpandableTable은 내부적으로 ScrollController를 갖고 있기 때문에,
    /// 데이터 변화에 즉각 Ui를 반영하지 못함 -> KeydSubtree로 state의 길이가 바뀔 때 마다 렌더링 해줌.
    return KeyedSubtree(
      key: ValueKey(state.length),
      child: _buildFixedTable(state, state.length, state[0].analyList.length),
    );
  }

  /// 테이블 데이터 생성
  Widget _buildFixedTable(
      List<PcRoomAnalytics> data, int pcLength, int timeLength) {
    // 컬럼 헤더 생성
    final List<ExpandableTableHeader> headers = List.generate(
      data.first.analyList.length,
      (index) => ExpandableTableHeader(
        width: 120,
        cell: _buildColumnHeader(data.first.analyList[index].time),
      ),
    );

    // 행 데이터 생성
    final List<ExpandableTableRow> rows = List.generate(
      data.length,
      (rowIndex) => ExpandableTableRow(
        height: 40,
        firstCell: _buildRowHeader(data[rowIndex].pcRoomName),
        cells: List.generate(
          timeLength,
          (columnIndex) {
            final timeUsage = data[rowIndex].analyList[columnIndex];
            return ExpandableTableCell(child: _buildCell('${timeUsage.count}'));
          },
        ),
      ),
    );

    return ExpandableTable(
      firstHeaderCell: ExpandableTableCell(child: _buildCell('PC 이름')),
      headers: headers,
      rows: rows,
      // 행 데이터
      scrollShadowColor: Colors.grey.shade400,
      visibleScrollbar: true,
      // trackVisibilityScrollbar: true,
      // thumbVisibilityScrollbar: true,
      headerHeight: 40,
      defaultsRowHeight: 50,
      defaultsColumnWidth: 120,
      firstColumnWidth: 150,
    );
  }

  /// 기본 셀 스타일
  Widget _buildCell(String content) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white, // 셀 배경색
          border: Border.all(color: Colors.grey, width: 0.5), // 테두리 추가
        ),
        padding: const EdgeInsets.all(8),
        child: Text(
          content,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      );

  /// 행 헤더 (고정)
  ExpandableTableCell _buildRowHeader(String text) {
    return ExpandableTableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Colors.grey.shade400, width: 1),
            bottom: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 컬럼 헤더 (고정)
  ExpandableTableCell _buildColumnHeader(String text) {
    return ExpandableTableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white, // 컬럼 헤더 색상
          border: Border(
            right: BorderSide(color: Colors.grey.shade400, width: 1),
            top: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
