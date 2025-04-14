import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class SelectedScrollTable extends StatefulWidget {
  const SelectedScrollTable({super.key});

  @override
  State<SelectedScrollTable> createState() => _SelectedScrollTableState();
}

class _SelectedScrollTableState extends State<SelectedScrollTable> {
  static const int columnsCount = 7; // 컬럼 개수
  static const int rowsCount = 30; // 행 개수

  @override
  Widget build(BuildContext context) {
    return _buildFixedTable();
  }

  /// 📌 기본 셀 스타일 (동적 너비 적용)
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

  /// 📌 행 헤더 (고정)
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

  /// 📌 컬럼 헤더 (고정)
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

  /// 📌 테이블 데이터 생성 (각 열 크기를 자동 조정)
  ExpandableTable _buildFixedTable() {
    final List<String> columnTitles = [
      "이름",
      "가동 PC 수",
      "평균 가동률",
      "PC 이용 매출",
      "식품 기타 매출",
      "총 매출",
      "요금제 비율",
    ];

    // 📌 컬럼 헤더 생성 (동적 너비 반영)
    final List<ExpandableTableHeader> headers = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
        width: 200, // 첫 번째 컬럼 넓이 다르게 설정
        cell: _buildColumnHeader(columnTitles[index]),
      ),
    );

    // 📌 행 데이터 생성
    final List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: 40, // 행 높이
        firstCell: _buildRowHeader('PC방 ${rowIndex + 1}'), // 행 헤더
        cells: List.generate(
          columnsCount,
          (columnIndex) => ExpandableTableCell(
            child: _buildCell('ㄷ개ㅑ서대ㅑㅓㅎ대갸허대ㅑ거해ㅑㄷ너해ㅑㄴ얼햐ㅐ'), // 동적으로 크기 조정
          ),
        ),
      ),
    );

    return ExpandableTable(
      firstHeaderCell: ExpandableTableCell(child: _buildCell('')),
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
