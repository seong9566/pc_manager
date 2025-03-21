import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class AllTableScreen extends StatefulWidget {
  const AllTableScreen({super.key});

  @override
  State<AllTableScreen> createState() => _AllTableScreenState();
}

class _AllTableScreenState extends State<AllTableScreen> {
  static const int columnsCount = 48; // 컬럼 개수
  static const int rowsCount = 20; // 행 개수

  @override
  Widget build(BuildContext context) {
    return _buildFixedTable();
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

  /// 테이블 데이터 생성
  ExpandableTable _buildFixedTable() {
    // 컬럼 헤더 생성
    final List<ExpandableTableHeader> headers = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
        width: 200, // 각 컬럼의 너비
        cell: _buildColumnHeader('Column $index'), // 고정 헤더
      ),
    );

    // 행 데이터 생성
    final List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: 40, // 행 높이
        firstCell: _buildRowHeader('Row $rowIndex'), // 행 헤더 고정
        cells: List.generate(
          columnsCount,
          (columnIndex) => ExpandableTableCell(
            child: _buildCell('000/000'), // Cell 내용
          ),
        ),
      ),
    );

    return ExpandableTable(
      firstHeaderCell: ExpandableTableCell(child: _buildCell('Table')),
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
}
