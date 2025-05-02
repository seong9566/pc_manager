import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/time_count_model.dart';
import '../analytics_viewmodel.dart';

class SelectedScrollTable extends ConsumerStatefulWidget {
  final List<PcStatModel> tableData;

  const SelectedScrollTable({required this.tableData, super.key});

  @override
  ConsumerState<SelectedScrollTable> createState() =>
      _SelectedScrollTableState();
}

class _SelectedScrollTableState extends ConsumerState<SelectedScrollTable> {
  final int columnsCount = 6;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(analyticsViewModelProvider);

    if (vmState.isLoading) {
      return SizedBox(
        height: 400,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.tableData.isEmpty) {
      return Center(
        child: Text(
          '데이터가 없습니다.\n이름을 모두 정확하게 입력해 주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }
    int rowsCount = widget.tableData.length; // 행 개수

    return _buildFixedTable(rowsCount);
  }

  ///  기본 셀 스타일 (동적 너비 적용)
  Widget _buildCell(
    String content, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white, // 셀 배경색
            border: Border.all(color: Colors.grey, width: 0.5), // 테두리 추가
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
          child: Text(
            content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: fontWeight,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      },
    );
  }

  ///  행 헤더 (고정)
  ExpandableTableCell _buildRowHeader(String text, {bool isHeader = false}) {
    return ExpandableTableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isHeader ? Colors.grey.shade200 : Colors.white, // 헤더 배경색 추가
          border: Border(
            left: BorderSide(color: Colors.grey.shade400, width: 1),
            bottom: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///  컬럼 헤더 (고정)
  ExpandableTableCell _buildColumnHeader(String text) {
    return ExpandableTableCell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // 컬럼 헤더 색상 추가
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
          );
        },
      ),
    );
  }

  ///  테이블 데이터 생성 (각 열 크기를 자동 조정)
  ExpandableTable _buildFixedTable(int rowsCount) {
    final List<String> columnTitles = [
      "가동 PC 수",
      "평균 가동률",
      "PC 이용 매출",
      "식품 기타 매출",
      "총 매출",
      "요금제 비율",
    ];

    // 컬럼 헤더 생성 (동적 너비 반영)
    final List<ExpandableTableHeader> headers = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
        width: 200, // 첫 번째 컬럼 넓이 다르게 설정
        cell: _buildColumnHeader(columnTitles[index]),
      ),
    );

    // 행 데이터 생성
    final List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) {
        final PcStatModel row = widget.tableData[rowIndex];
        return ExpandableTableRow(
          height: 40,
          firstCell: _buildRowHeader(row.pcName), // 행 헤더
          cells: [
            ExpandableTableCell(child: _buildCell(row.usedPcFormatted)),
            ExpandableTableCell(child: _buildCell(row.averageRate)),
            ExpandableTableCell(child: _buildCell(row.pcPriceFormatted)),
            ExpandableTableCell(child: _buildCell(row.foodPriceFormatted)),
            ExpandableTableCell(child: _buildCell(row.totalPriceFormatted)),
            ExpandableTableCell(child: _buildCell(row.pricePercentFormatted)),
          ],
        );
      },
    );

    return ExpandableTable(
      firstHeaderCell: ExpandableTableCell(child: _buildCell('이름')),
      headers: headers,
      rows: rows,
      scrollShadowColor: Colors.grey.shade400,
      visibleScrollbar: true,
      headerHeight: 40,
      defaultsRowHeight: 50,
      defaultsColumnWidth: 120,
      firstColumnWidth: 150,
    );
  }
}
