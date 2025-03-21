import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';

const double nameWidth = 150;
const double addressWidth = 180;
const double ipWidth = 160;
const double portWidth = 80;
const double seatWidth = 80;
const double priceWidth = 120;
const double specificationWidth = 180;
const double agencyWidth = 100;
const double memoWidth = 160;
const double actionWidth = 100;

class ManagementBody extends ConsumerStatefulWidget {
  const ManagementBody({super.key});

  @override
  ConsumerState<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends ConsumerState<ManagementBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 24),
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
            /// 📌 Title & Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '분석중인 매장들',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ref.read(baseViewIndexProvider.notifier).state = 3;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      '매장 추가',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            /// 📌 가로 스크롤 적용
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📌 테이블 헤더
                      Row(
                        children: [
                          _bodyTitleText('이름', nameWidth),
                          _bodyTitleText('주소', addressWidth),
                          _bodyTitleText('IP', ipWidth),
                          _bodyTitleText('포트', portWidth),
                          _bodyTitleText('좌석수', seatWidth),
                          _bodyTitleText('요금제 가격', priceWidth),
                          _bodyTitleText('PC 사양', specificationWidth),
                          _bodyTitleText('통신사', agencyWidth),
                          _bodyTitleText('메모', memoWidth),
                          _bodyTitleText('액션', actionWidth),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(height: 1, color: Colors.black),

                      /// 📌 세로 스크롤 추가
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(20, (index) {
                              return Column(
                                children: [
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _bodyContentText('옐로우 피씨방', nameWidth),
                                      _bodyContentText(
                                        '서울시 관악구 조원동',
                                        addressWidth,
                                      ),
                                      _bodyContentText(
                                        '255.255.255.255',
                                        ipWidth,
                                      ),
                                      _bodyContentText('8080', portWidth),
                                      _bodyContentText('128', seatWidth),
                                      _bodyContentText('9,000', priceWidth),
                                      _bodyContentText(
                                        'RTX4070 Ti',
                                        specificationWidth,
                                      ),
                                      _bodyContentText('SKT', agencyWidth),
                                      _bodyContentText('메모 예시 작성', memoWidth),
                                      _bodyContentButtons(),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Divider(height: 1, color: Colors.grey),
                                ],
                              );
                            }),
                          ),
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

  /// 📌 액션 버튼
  Widget _bodyContentButtons() {
    return Column(
      children: [
        _contentBtn('수정', Colors.yellow.shade800),
        SizedBox(height: 4),
        _contentBtn('삭제', Colors.redAccent),
        SizedBox(height: 4),
        _contentBtn('분석', Colors.purpleAccent),
      ],
    );
  }

  Widget _contentBtn(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 📌 본문 텍스트
  Widget _bodyContentText(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 📌 헤더 텍스트
  Widget _bodyTitleText(String title, double width) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
