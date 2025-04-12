import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';
import 'package:kpostal_web/kpostal_web.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/screen_size.dart';
import '../../../model/management_model.dart';
import '../../../widgets/custom_text_field.dart';

class StoreAddView extends ConsumerStatefulWidget {
  const StoreAddView({super.key});

  @override
  ConsumerState<StoreAddView> createState() => _StoreAddViewState();
}

class _StoreAddViewState extends ConsumerState<StoreAddView> {
  late TextEditingController _nameController,
      _cityController,
      _townController,
      _countryController,
      _ipController,
      _portController,
      _seatController,
      _priceController,
      _rateOfPlanController,
      _specController,
      _agencyController,
      _memoController;

  late String address;

  @override
  void initState() {
    super.initState();
    _initializeControllers(null);
  }

  void _initializeControllers(ManagementModel? item) {
    final parsed = splitAddress(item?.addr ?? '');
    address = item?.addr ?? '';
    _nameController = TextEditingController(text: item?.name);
    _cityController = TextEditingController(text: parsed['city']);
    _townController = TextEditingController(text: parsed['town']);
    _countryController = TextEditingController(text: parsed['country']);
    _ipController = TextEditingController(text: item?.ip);
    _portController = TextEditingController(text: item?.port?.toString() ?? '');
    _seatController =
        TextEditingController(text: item?.seatNumber?.toString() ?? '');
    _priceController =
        TextEditingController(text: item?.price?.toString() ?? '');
    _rateOfPlanController =
        TextEditingController(text: item?.pricePercent?.toString() ?? '');
    _specController = TextEditingController(text: item?.pcSpec);
    _agencyController = TextEditingController(text: item?.telecom);
    _memoController = TextEditingController(text: item?.memo);
  }

  Map<String, String> splitAddress(String address) {
    final parts = address.trim().split(RegExp(r'\s+'));

    String extractRoadName(String input) {
      // 숫자나 '길', '로', '번길' 등이 붙기 전까지 잘라냄
      final match = RegExp(r'^[가-힣]+').firstMatch(input);
      return match?.group(0) ?? '';
    }

    return {
      'city': parts.isNotEmpty ? parts[0] : '',
      'town': parts.length > 1 ? parts[1] : '',
      'country': parts.length > 2 ? extractRoadName(parts[2]) : '',
    };
  }

  void openAddressDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "KAKAO Address",
      pageBuilder: (_, __, ___) {
        return KakaoAddressWidget(
          onComplete: (kakaoAddress) {
            print('onComplete KakaoAddress: ${kakaoAddress.address}');
            final parsed = splitAddress(kakaoAddress.address);

            setState(() {
              address = kakaoAddress.address;
              _cityController.text = parsed['city'] ?? '';
              _townController.text = parsed['town'] ?? '';
              _countryController.text = parsed['country'] ?? '';
            });
          },
          onClose: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void addStore() {
    final selectedStore = ref.read(selectedStoreProvider);
    final isEdit = selectedStore != null && !selectedStore.isEmpty;

    final ip = _ipController.text.trim();
    final port = int.parse(_portController.text.trim());
    final name = _nameController.text.trim();
    final seatNumber = int.parse(_seatController.text.trim());
    final price = double.parse(_priceController.text.trim());
    final pricePercent = double.parse(_rateOfPlanController.text.trim());
    final pcSpec = _specController.text.trim();
    final telecom = _agencyController.text.trim();
    final memo = _memoController.text.trim();

    if (isEdit) {
      final pId = selectedStore.pId!;
      ref
          .read(managementViewModelProvider.notifier)
          .updateStore(
            pId: pId,
            ip: ip,
            port: port,
            name: name,
            seatNumber: seatNumber,
            price: price,
            pricePercent: pricePercent,
            pcSpec: pcSpec,
            telecom: telecom,
            memo: memo,
          )
          .then((resultMessage) {
        if (mounted) {
          resultDialog(context, resultMessage!.message, resultMessage.data);
        }
      });
    } else {
      ref
          .read(managementViewModelProvider.notifier)
          .addStore(
            ip: ip,
            port: port,
            name: name,
            addr: address.trim(),
            seatNumber: seatNumber,
            price: price,
            pricePercent: pricePercent,
            countryName: _cityController.text.trim(),
            cityName: _townController.text.trim(),
            townName: _countryController.text.trim(),
            pcSpec: pcSpec.isEmpty ? null : pcSpec,
            telecom: telecom.isEmpty ? null : telecom,
            memo: memo.isEmpty ? null : memo,
          )
          .then((resultMessage) {
        if (mounted) {
          resultDialog(context, resultMessage!.message, resultMessage.data);
        }
      });
    }
  }

  void resultDialog(BuildContext context, String message, bool result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("PC방 추가"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (result) {
                ref.read(managementViewModelProvider.notifier).getStoreList();
                ref.read(baseViewIndexProvider.notifier).state = 1;
              }
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  void cancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('정말 취소하시겠습니까?'),
        content: Text('입력한 정보가 모두 사라집니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('아니요'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(selectedStoreProvider.notifier).state =
                  ManagementModel.empty();
              ref.read(baseViewIndexProvider.notifier).state = 1;
            },
            child: Text('네'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ManagementModel?>(
      selectedStoreProvider,
      (prev, next) {
        _initializeControllers(next);
        setState(() {});
      },
    );

    final isEdit = ref.watch(selectedStoreProvider)?.isEmpty == false;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        top: 20,
        bottom: 20,
        right: Responsive.isDesktop(context) ? 500 : 24,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [AppTheme.greyShadow],
        ),
        child: _body(isEdit),
      ),
    );
  }

  Widget _body(bool isEdit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text('PC방 추가',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        CustomTextField(hintText: 'PC방 이름', controller: _nameController),
        SizedBox(height: 20),
        _addressRow(isEdit),
        SizedBox(height: 20),

        /// 주소는 ReadOnly
        Row(children: [
          CustomTextField(
              hintText: 'AA시', controller: _cityController, isEdit: true),
          SizedBox(width: 10),
          CustomTextField(
              hintText: 'BB구', controller: _townController, isEdit: true),
          SizedBox(width: 10),
          CustomTextField(
              hintText: 'CC동', controller: _countryController, isEdit: true),
        ]),
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
            hintText: 'PC 요금제 비율', controller: _rateOfPlanController),
        SizedBox(height: 20),
        CustomTextField(hintText: 'PC 사양', controller: _specController),
        SizedBox(height: 20),
        CustomTextField(hintText: '통신사', controller: _agencyController),
        SizedBox(height: 20),
        CustomTextField(hintText: '메모', controller: _memoController),
        SizedBox(height: 20),
        Row(
          children: [
            _buttonItem('추가', AppColors.purpleColor, addStore),
            SizedBox(width: 20),
            _buttonItem('취소', AppColors.purpleColor, cancelDialog),
          ],
        ),
      ],
    );
  }

  Widget _addressRow(bool isEdit) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 12),
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              address.isEmpty ? '주소를 입력해 주세요.' : address,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
        if (!isEdit) ...[
          SizedBox(width: 20),
          _buttonItem('주소 검색', AppColors.purpleColor, () {
            openAddressDialog(context);
          }),
        ]
      ],
    );
  }

  Widget _buttonItem(String text, Color color, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}
