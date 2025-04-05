import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/model/management_model.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';

const double nameWidth = 180;
const double addressWidth = 200;
const double ipWidth = 160;
const double portWidth = 80;
const double seatWidth = 100;
const double priceWidth = 120;
const double specificationWidth = 200;
const double agencyWidth = 100;
const double memoWidth = 200;
const double actionWidth = 100;

const double totalWidth = nameWidth +
    addressWidth +
    ipWidth +
    portWidth +
    seatWidth +
    priceWidth +
    specificationWidth +
    agencyWidth +
    memoWidth +
    actionWidth;

class ManagementBody extends ConsumerStatefulWidget {
  const ManagementBody({super.key});

  @override
  ConsumerState<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends ConsumerState<ManagementBody> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managementViewModelProvider);
    return state.when(
      data: (management) {
        return Expanded(child: _body(management));
      },
      error: (error, stack) => Center(child: Text('새로 고침 해주세요.')),
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _body(List<ManagementModel> item) {
    return Container(
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
          ///  Title & Button
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
              // Text("선택된 옵션 : 서울시 관악구 조원로"),
              // Text("총 매장 수 : 2개"),
              GestureDetector(
                onTap: () {
                  setState(() {
                    ref.read(baseViewIndexProvider.notifier).state = 3;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.purpleColor,
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

          /// 가로 스크롤 적용
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///  테이블 헤더
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

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: item.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              SizedBox(height: 6),
                              _contentItem(item[index]),
                              SizedBox(height: 6),
                              Divider(height: 1, color: Colors.grey),
                            ],
                          );
                        },
                      ),
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

  Widget _contentItem(ManagementModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _bodyContentText(item.name, nameWidth),
        _bodyContentText(item.addr, addressWidth),
        _bodyContentText(item.ip, ipWidth),
        _bodyContentText(item.port.toString(), portWidth),
        _bodyContentText(item.seatNumber.toString(), seatWidth),
        _bodyContentText(item.price.toString(), priceWidth),
        _bodyContentText(item.pcSpec, specificationWidth),
        _bodyContentText(item.telecom, agencyWidth),
        _bodyContentText(item.memo, memoWidth),
        _bodyContentButtons(),
      ],
    );
  }

  ///  액션 버튼
  Widget _bodyContentButtons() {
    return Column(
      children: [
        _contentBtn('수정', AppColors.yellowColor),
        SizedBox(height: 4),
        _contentBtn('삭제', AppColors.redColor),
        SizedBox(height: 4),
        _contentBtn('분석', AppColors.purpleColor),
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

  ///  본문 텍스트
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

  ///  헤더 텍스트
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
