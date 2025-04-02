import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/model/dash_board_model.dart';

import '../../../../model/management_model.dart';
import '../dash_board_viewmodel.dart';

const double nameWidth = 160;
const double addressWidth = 190;
const double ipWidth = 160;
const double portWidth = 100;
const double rateWidth = 200;

const List<double> analyzeResultWidthList = [nameWidth, rateWidth];
const List<double> analyzingWidthList = [
  nameWidth,
  addressWidth,
  ipWidth,
  portWidth,
];

class DashBoardBody extends ConsumerStatefulWidget {
  const DashBoardBody({super.key});

  @override
  ConsumerState<DashBoardBody> createState() => _DashBoardBodyState();
}

class _DashBoardBodyState extends ConsumerState<DashBoardBody> {
  @override
  Widget build(BuildContext context) {
    /// 최근 분석 결과 데이터
    final state = ref.watch(dashBoardViewModelProvider).dashBoardModel;
    final storeState = ref.watch(managementViewModelProvider).value;

    /// 최근 분석중인 매장 데이터는 storeList에서 뽑아써야함.

    if (state == null || storeState == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///  분석중인 매장 테이블
          Expanded(
            child: _buildAnalyzingTable(
              title: '분석중인 매장들',
              headers: ['이름', '주소', 'IP', '포트'],
              data: storeState,
            ),
          ),

          // ///  최근 분석 결과 테이블
          Expanded(
            child: _buildAnalyzeResultTable(
              title: '최근 분석결과',
              headers: ['매장 이름', '가동률'],
              data: state.data.datas,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingTable({
    required String title,
    required List<String> headers,
    required List<ManagementModel> data,
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
          ///  제목
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          /// 컬럼 헤더
          Row(
            children: [
              SizedBox(
                width: analyzingWidthList[0],
                child: Text(
                  '이름',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: analyzingWidthList[1],
                child: Text(
                  '주소',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: analyzingWidthList[2],
                child: Text(
                  'IP',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: analyzingWidthList[3],
                child: Text(
                  '포트',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(height: 1, color: Colors.black),

          ///  데이터 리스트
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      width: analyzingWidthList[0],
                      child: Text(
                        data[index].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: analyzingWidthList[1],
                      child: Text(
                        data[index].addr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: analyzingWidthList[2],
                      child: Text(
                        data[index].ip,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: analyzingWidthList[3],
                      child: Text(
                        data[index].port.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 최근 분석 결과 테이블
  Widget _buildAnalyzeResultTable({
    required String title,
    required List<String> headers,
    required List<DashBoardStoreData> data,
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
          ///  제목
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          /// 컬럼 헤더
          Row(
            children: [
              SizedBox(
                width: analyzeResultWidthList[0],
                child: Text(
                  '매장 이름',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: analyzeResultWidthList[1],
                child: Text(
                  '가동률',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(height: 1, color: Colors.black),

          ///  데이터 리스트
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      width: analyzeResultWidthList[0],
                      child: Text(
                        data[index].pcRoomName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: analyzeResultWidthList[1],
                      child: Text(
                        data[index].returnRate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Expanded(
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.vertical,
          //     child: Column(
          //       children: List.generate(
          //         data.length,
          //         (rowIndex) => Column(
          //           children: [
          //             SizedBox(height: 12),
          //             Row(
          //               children: List.generate(
          //                 headers.length,
          //                 (colIndex) => SizedBox(
          //                   width: columnWidths[colIndex],
          //                   child: Text(
          //                     data[rowIndex][colIndex],
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.normal,
          //                       color: Colors.grey,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(height: 6),
          //             Divider(height: 1, color: Colors.grey),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
