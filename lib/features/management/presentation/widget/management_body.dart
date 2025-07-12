import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_colors.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/features/management/presentation/widget/hover_button.dart';
import 'package:ip_manager/model/management_model.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';
import 'package:ip_manager/widgets/dot_dialog.dart';

import '../../../../model/ping_model.dart';
import 'management_skeleton.dart';

const double nameWidth = 180;
const double addressWidth = 200;
const double ipWidth = 160;
const double portWidth = 80;
const double seatWidth = 100;
const double priceWidth = 120;
const double pricePercent = 120;
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
    pricePercent +
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
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managementViewModelProvider);
    // return Center(child: ManagementSkeleton());
    return state.when(
        data: (management) {
          return _body(management);
        },
        error: (error, stack) => Center(child: Text('새로 고침 해주세요.')),
        loading: () {
          return Center(
            child: ManagementSkeleton(),
          );
        });
  }

  Widget _body(List<ManagementModel> item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.mainBorder,
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
          Responsive.isDesktop(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '분석중인 매장들',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '총 매장 수 : ${item.length}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.mainTextColor,
                      ),
                    ),
                    Spacer(),
                    HoverButton(
                      text: "매장 추가",
                      icon: Icons.add,
                      color: AppColors.purpleColor,
                      onTap: () {
                        setState(() {
                          ref.read(tabIndexProvider.notifier).select(3);
                        });
                      },
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '분석중인 매장들',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    HoverButton(
                      text: "매장 추가",
                      icon: Icons.add,
                      color: AppColors.purpleColor,
                      onTap: () {
                        setState(() {
                          ref.read(tabIndexProvider.notifier).select(3);
                        });
                      },
                    ),
                  ],
                ),
          const SizedBox(height: 16),

          /// 가로 스크롤 + 고정 헤더 + 세로 스크롤
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 6.0,
                  radius: const Radius.circular(10.0),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: totalWidth,
                      // 이 높이가 곧 ListView 의 maxHeight 가 됨
                      height: constraints.maxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── 테이블 헤더 (고정) ─────────────────
                          Row(
                            children: [
                              _bodyTitleText('이름', nameWidth),
                              _bodyTitleText('주소', addressWidth),
                              _bodyTitleText('IP', ipWidth),
                              _bodyTitleText('포트', portWidth),
                              _bodyTitleText('좌석수', seatWidth),
                              _bodyTitleText('요금제 가격', priceWidth),
                              _bodyTitleText('요금제 비율', pricePercent),
                              _bodyTitleText('PC 사양', specificationWidth),
                              _bodyTitleText('통신사', agencyWidth),
                              _bodyTitleText('메모', memoWidth),
                              _bodyTitleText('액션', actionWidth),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(
                              height: 1, color: AppColors.dividerColor),

                          // ─── 데이터 리스트 (스크롤 가능) ─────────────────────
                          Flexible(
                            child: ListView.separated(
                              itemCount: item.length,
                              separatorBuilder: (_, __) => const Divider(
                                  height: 1, color: AppColors.dividerColor),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: _contentItem(item[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
        _bodyContentText(item.name!, nameWidth),
        _bodyContentText(item.addr!, addressWidth),
        _bodyContentText(item.ip!, ipWidth),
        _bodyContentText(item.port.toString(), portWidth),
        _bodyContentText(item.seatNumber.toString(), seatWidth),
        _bodyContentText(item.price.toString(), priceWidth),
        _bodyContentText(item.pricePercent.toString(), pricePercent),
        _bodyContentText(item.pcSpec!, specificationWidth),
        _bodyContentText(item.telecom!, agencyWidth),
        _bodyContentText(item.memo!, memoWidth),
        _bodyContentButtons(item),
      ],
    );
  }

  ///  액션 버튼
  Widget _bodyContentButtons(ManagementModel item) {
    return Column(
      children: [
        HoverButton(
          icon: Icons.edit,
          text: '수정',
          color: AppColors.greenColor,
          onTap: () {
            ref.read(selectedStoreProvider.notifier).state = item;
            ref.read(tabIndexProvider.notifier).select(3);
          },
        ),
        const SizedBox(height: 4),
        HoverButton(
          icon: Icons.delete,
          text: '삭제',
          color: AppColors.redColor,
          onTap: () {
            showDeleteDialog(context, item.name!, item.pId!);
          },
        ),
        const SizedBox(height: 4),
        HoverButton(
          text: '분석',
          icon: Icons.analytics,
          color: AppColors.purpleColor,
          onTap: () async {
            if (item.pId == null) return;

            // 1) 로딩 다이얼로그 띄우기
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            try {
              final data = await ref
                  .read(managementViewModelProvider.notifier)
                  .sendIpPing(pId: item.pId!);

              // 2) 다이얼로그 닫기 (팝이 가능할 때만)
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }

              // 3) 데이터 유무 체크
              if (data == null) {
                throw Exception("no data");
              }

              // 4) 정상 로직
              showPingDialog(context, item.name ?? '', data);
            } catch (_) {
              // 에러가 났어도 다이얼로그가 남아있으면 닫고
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              showFailedToast(context,
                  "네트워크 상태가 불안정합니다.\n다시 시도하거나 ${item.name}의 연결을 확인해주세요.");
            }
          },
        ),
      ],
    );
  }

  // Widget _bodyContentButtons(ManagementModel item) {
  //   return Column(
  //     children: [
  //       _contentBtn('수정', AppColors.yellowColor, () {
  //         ref.read(selectedStoreProvider.notifier).state = item;
  //         ref.read(tabIndexProvider.notifier).select(3);
  //       }),
  //       SizedBox(height: 4),
  //       _contentBtn('삭제', AppColors.redColor, () {
  //         showDeleteDialog(context, item.name!, item.pId!);
  //       }),
  //       SizedBox(height: 4),
  //       _contentBtn('분석', AppColors.purpleColor, () async {
  //         if (item.pId == null) {
  //           debugPrint("[Flutter] >> pId is null");
  //         }
  //         // 로딩 다이얼로그 먼저 띄우기
  //         showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (_) {
  //             return const Center(child: CircularProgressIndicator());
  //           },
  //         );
  //
  //         // 데이터 요청
  //         final data = await ref
  //             .read(managementViewModelProvider.notifier)
  //             .sendIpPing(pId: item.pId!);
  //         // 로딩 다이얼로그 닫기
  //         if (context.mounted) {
  //           Navigator.of(context).pop();
  //         }
  //
  //         if (data == null) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('PING 데이터를 불러오지 못했습니다')),
  //           );
  //           return;
  //         }
  //
  //         // 결과 다이얼로그 띄우기
  //         showPingDialog(context, item.name ?? '', data);
  //       }),
  //     ],
  //   );
  // }

  void showDeleteDialog(BuildContext context, String storeName, int pId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            title: Text("PC방 삭제"),
            content: Text("$storeName을 정말 삭제 하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref
                      .read(managementViewModelProvider.notifier)
                      .deleteStore(pId: pId);
                  ref.read(tabIndexProvider.notifier).select(1);
                },
                child: const Text("확인"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("취소"),
              ),
            ],
          );
        });
  }

  void showPingDialog(BuildContext context, String storeName, PingModel ping) {
    String pingStatus = "${ping.used} / ${ping.unUsed + ping.used}";
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        '현재 활성 PING 수',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pingStatus,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget _contentBtn(String text, Color color, Function onTap) {
  //   return GestureDetector(
  //     onTap: () {
  //       onTap();
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.all(Radius.circular(8)),
  //       ),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
