import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';
import 'package:kpostal_web/kpostal_web.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/screen_size.dart';
import '../../../widgets/custom_text_field.dart';

class StoreAddView extends ConsumerStatefulWidget {
  const StoreAddView({super.key});

  @override
  ConsumerState<StoreAddView> createState() => _StoreAddViewState();
}

class _StoreAddViewState extends ConsumerState<StoreAddView> {
  final TextEditingController _nameController =
      TextEditingController(text: '자드 피시방');
  String address = '부산 부산진구 신천대로50번길 68';

  // TextEditingController _addressController = TextEditingController();

  /// 시
  final TextEditingController _cityController =
      TextEditingController(text: '부산시');

  /// 군
  final TextEditingController _districtController =
      TextEditingController(text: '진구');

  /// 구
  final TextEditingController _neighborhoodController =
      TextEditingController(text: '신천대로');

  final TextEditingController _ipController =
      TextEditingController(text: '127.0.0.1');
  final TextEditingController _portController =
      TextEditingController(text: '5040');
  final TextEditingController _seatController =
      TextEditingController(text: '100');
  final TextEditingController _priceController =
      TextEditingController(text: '1500');
  final TextEditingController _rateOfPlanController =
      TextEditingController(text: '55');
  final TextEditingController _specController =
      TextEditingController(text: 'GTX4080');
  final TextEditingController _agencyController =
      TextEditingController(text: 'SKT');
  final TextEditingController _memoController =
      TextEditingController(text: '알바 2명 구해야함.');

  void openAddressDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "KAKAO Arress",
        pageBuilder: (_, __, ___) {
          return KakaoAddressWidget(onComplete: (kakaoAddress) {
            print('onComplete KakaoAddress: $kakaoAddress');
            setState(() {
              address = kakaoAddress.address;
            });

            /// 우편번호: 08701, 주소: 서울 관악구 조원로17길 26
          }, onClose: () {
            Navigator.pop(context);
          });
        });
  }

  void addStore() {
    final resultMessage = ref
        .read(managementViewModelProvider.notifier)
        .addStore(
          ip: _ipController.text.trim(),
          port: int.parse(_portController.text.trim()),
          name: _nameController.text.trim(),
          addr: address.trim(),
          seatNumber: int.parse(_seatController.text.trim()),
          price: double.parse(_priceController.text.trim()),
          pricePercent: double.parse(_rateOfPlanController.text.trim()),
          countryName: _cityController.text.trim(),
          cityName: _districtController.text.trim(),
          townName: _neighborhoodController.text.trim(),
          pcSpec: _specController.text.trim(),
          telecom: _agencyController.text.trim(),
          memo: _memoController.text.trim(),
        )
        .then((resultMessage) {
      if (mounted) {
        resultDialog(context, resultMessage!.message, resultMessage.data);
      }
    });
  }

  void resultDialog(BuildContext context, String message, bool result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("PC방 추가"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                if (result) {
                  ref.read(managementViewModelProvider.notifier).getStoreList();
                  ref.read(baseViewIndexProvider.notifier).state = 1;
                }
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 24,
          top: 20,
          bottom: 20,
          right: Responsive.isDesktop(context) ? 500 : 24),
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [AppTheme.greyShadow],
        ),
        child: _body(context),
      ),
    );
  }

  Column _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'PC방 추가',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20),
        CustomTextField(hintText: 'PC방 이름', controller: _nameController),
        SizedBox(height: 20),
        Row(
          children: [
            _addressField(),
            SizedBox(width: 20),
            _buttonItem('주소 검색', AppColors.purpleColor, () {
              openAddressDialog(context);
            }),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            CustomTextField(
              isSubAddress: true,
              hintText: 'AA시',
              controller: _cityController,
            ),
            SizedBox(width: 10),
            CustomTextField(
              isSubAddress: true,
              hintText: 'BB구',
              controller: _districtController,
            ),
            SizedBox(width: 10),
            CustomTextField(
              isSubAddress: true,
              hintText: 'CC동',
              controller: _neighborhoodController,
            ),
          ],
        ),
        SizedBox(height: 20),
        CustomTextField(hintText: 'IP', controller: _ipController),
        SizedBox(height: 20),
        CustomTextField(hintText: 'Port', controller: _portController),
        SizedBox(height: 20),
        CustomTextField(hintText: '좌석 수', controller: _seatController),
        SizedBox(height: 20),
        CustomTextField(hintText: '요금제 가격', controller: _priceController),
        SizedBox(height: 20),
        CustomTextField(
          hintText: 'PC 요금제 비율',
          controller: _rateOfPlanController,
        ),
        SizedBox(height: 20),
        CustomTextField(hintText: 'PC 사양', controller: _specController),
        SizedBox(height: 20),
        CustomTextField(hintText: '통신사', controller: _agencyController),
        SizedBox(height: 20),
        CustomTextField(hintText: '메모', controller: _memoController),
        SizedBox(height: 20),
        _bottomRowBtn(),
      ],
    );
  }

  Expanded _addressField() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 12),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            address == '' ? '주소를 입력해 주세요.' : address,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _bottomRowBtn() {
    return Row(
      children: [
        _buttonItem('추가', AppColors.purpleColor, () {
          addStore();
        }),
        SizedBox(width: 20),
        _buttonItem('취소', AppColors.purpleColor, () {
          /// TODO : 취소
        }),
      ],
    );
  }

  Widget _buttonItem(String text, Color color, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
