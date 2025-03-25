import 'package:flutter/material.dart';

const double nameWidth = 160;
const double addressWidth = 190;
const double ipWidth = 160;
const double portWidth = 100;

class DashBoardBody extends StatelessWidget {
  const DashBoardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📌 분석중인 매장 테이블
          Expanded(
            child: _buildTableContainer(
              title: '분석중인 매장들',
              headers: ['이름', '주소', 'IP', '포트'],
              columnWidths: [nameWidth, addressWidth, ipWidth, portWidth],
              data: List.generate(
                20,
                (index) => [
                  '옐로우 피씨방',
                  '서울시 관악구 조원동',
                  '255.255.255.255',
                  '8080',
                ],
              ),
            ),
          ),

          /// 📌 최근 분석 결과 테이블
          Expanded(
            child: _buildTableContainer(
              title: '최근 분석결과',
              headers: ['매장 이름', '가동률'],
              columnWidths: [nameWidth * 1.5, nameWidth],
              data: List.generate(
                20,
                (index) => ['그린 피씨방', '운영중인 PC / 총 PC (47%)'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 테이블 컨테이너 위젯
  Widget _buildTableContainer({
    required String title,
    required List<String> headers,
    required List<double> columnWidths,
    required List<List<String>> data,
  }) {
    return Container(
      // 테이블 전체 크기
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(0, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📌 제목
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          /// 📌 컬럼 헤더
          Row(
            children: List.generate(
              headers.length,
              (index) => SizedBox(
                width: columnWidths[index],
                child: Text(
                  headers[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Divider(height: 1, color: Colors.black),

          /// 📌 데이터 리스트
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(
                  data.length,
                  (rowIndex) => Column(
                    children: [
                      SizedBox(height: 12),
                      Row(
                        children: List.generate(
                          headers.length,
                          (colIndex) => SizedBox(
                            width: columnWidths[colIndex],
                            child: Text(
                              data[rowIndex][colIndex],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Divider(height: 1, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
