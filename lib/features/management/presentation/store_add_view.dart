import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/app_theme.dart';
import 'package:ip_manager/features/analytics/presentation/analytics_viewmodel.dart';
import 'package:ip_manager/features/management/presentation/management_viewmodel.dart';
import 'package:ip_manager/provider/base_view_index_provider.dart';
import 'package:kpostal_web/kpostal_web.dart';
import 'package:toastification/toastification.dart';

import '../../../core/config/screen_size.dart';
import '../../../model/management_model.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/ip_address_field.dart';

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
      _pricePercentController,
      _specController,
      _agencyController,
      _memoController;

  late String address;

  @override
  void initState() {
    super.initState();
    _initializeControllers(null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _townController.dispose();
    _countryController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _seatController.dispose();
    _priceController.dispose();
    _pricePercentController.dispose();
    _specController.dispose();
    _agencyController.dispose();
    _memoController.dispose();
    super.dispose();
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
    _pricePercentController =
        TextEditingController(text: item?.pricePercent?.toString() ?? '');
    _specController = TextEditingController(text: item?.pcSpec);
    _agencyController = TextEditingController(text: item?.telecom);
    _memoController = TextEditingController(text: item?.memo);
  }

  Map<String, String> splitAddress(String address) {
    final parts = address.trim().split(RegExp(r'\s+'));
    String extractRoadName(String input) {
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
      pageBuilder: (dContext, __, ___) {
        return Dialog(
          child: Container(
            height: 500,
            width: 500,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: KakaoAddressWidget(
              onComplete: (kakaoAddress) {
                final parsed = splitAddress(kakaoAddress.address);
                setState(() {
                  address = kakaoAddress.address;
                  _cityController.text = parsed['city'] ?? '';
                  _townController.text = parsed['town'] ?? '';
                  _countryController.text = parsed['country'] ?? '';
                });
              },
              onClose: () => Navigator.pop(dContext),
            ),
          ),
        );
      },
    );
  }

  void showToast(String text) {
    toastification.show(
      context: context,
      showIcon: true,
      icon: Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 28,
      ),
      backgroundColor: Colors.redAccent,
      autoCloseDuration: const Duration(milliseconds: 2000),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.visible,
      ),
      alignment: Alignment.topCenter,
    );
  }

  void addStore() {
    final percentText = _pricePercentController.text.trim();
    if (percentText.isEmpty) {
      // 비어 있으면 에러 메시지 출력 후 리턴

      showToast("PC 요금제 비율을 입력해주세요.");
      return;
    }
    final pricePercent = double.tryParse(percentText);
    if (pricePercent == null) {
      // 숫자로 파싱되지 않으면 에러
      showToast("올바른 숫자 형식으로 입력해주세요.");
      return;
    }

    final selectedStore = ref.read(selectedStoreProvider);
    final isEdit = selectedStore != null && !selectedStore.isEmpty;
    final ip = _ipController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 0;
    final name = _nameController.text.trim();
    final seatNumber = int.tryParse(_seatController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final pcSpec = _specController.text.trim();
    final telecom = _agencyController.text.trim();
    final memo = _memoController.text.trim();

    final notifier = ref.read(managementViewModelProvider.notifier);
    final future = isEdit
        ? notifier.updateStore(
            pId: selectedStore.pId!,
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
        : notifier.addStore(
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
          );

    future.then((resultMessage) {
      if (mounted && resultMessage != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(isEdit ? '수정 완료' : '추가 완료'),
            content: Text(resultMessage.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(managementViewModelProvider.notifier).getStoreList();
                  ref
                      .read(analyticsViewModelProvider.notifier)
                      .getThisDayDataList(targetDate: DateTime.now());
                  ref.read(tabIndexProvider.notifier).select(1);
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    });
  }

  void cancelDialog(bool isEdit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('정말 취소하시겠습니까?'),
        content: Text(isEdit ? '수정한 내용은 저장 되지 않습니다.' : '입력한 정보가 모두 사라집니다.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('아니요')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(selectedStoreProvider.notifier).state =
                  ManagementModel.empty();
              ref.read(tabIndexProvider.notifier).select(1);
              _initializeControllers(null);
            },
            child: const Text('네'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ManagementModel?>(
      selectedStoreProvider,
      (_, next) {
        _initializeControllers(next);
        setState(() {});
      },
    );
    final isEdit = ref.watch(selectedStoreProvider)?.isEmpty == false;

    return Padding(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                // 뒤로가기
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    cancelDialog(isEdit);
                  },
                ),
                const SizedBox(width: 16),
                Text(isEdit ? 'PC방 수정' : 'PC방 추가',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // 이 Expanded가 반드시 Column의 직계 자식이어야 합니다.
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  CustomTextField(
                    labelText: 'PC방 이름',
                    hintText: 'PC방 이름을 입력하세요',
                    controller: _nameController,
                    useExpanded: false,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  _addressRow(isEdit),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomTextField(
                        labelText: '시',
                        hintText: 'AA시',
                        controller: _cityController,
                        isEdit: true,
                        useExpanded: true,
                        isRequired: true,
                      ),
                      const SizedBox(width: 8),
                      CustomTextField(
                        labelText: '구',
                        hintText: 'BB구',
                        controller: _townController,
                        isEdit: true,
                        useExpanded: true,
                        isRequired: true,
                      ),
                      const SizedBox(width: 8),
                      CustomTextField(
                        labelText: '동',
                        hintText: 'CC동',
                        controller: _countryController,
                        isEdit: true,
                        useExpanded: true,
                        isRequired: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'IP 주소',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '잘못 입력시 분석이 정상적으로 되지 않습니다.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IPAddressField(
                        controller: _ipController,
                        isReadOnly: false, // 항상 수정 가능하도록 설정
                        hintText: 'IP',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: '포트',
                    hintText: '포트를 입력하세요',
                    controller: _portController,
                    useExpanded: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: '좌석 수',
                    hintText: '좌석 수를 입력하세요',
                    controller: _seatController,
                    useExpanded: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: '요금제 가격',
                    hintText: '요금제 가격을 입력하세요',
                    controller: _priceController,
                    useExpanded: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'PC 요금제 비율',
                    hintText: 'PC 요금제 비율을 입력하세요',
                    controller: _pricePercentController,
                    useExpanded: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'PC 사양',
                    hintText: 'PC 사양을 입력하세요',
                    controller: _specController,
                    useExpanded: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: '통신사',
                    hintText: '통신사를 입력하세요',
                    controller: _agencyController,
                    useExpanded: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: '메모',
                    hintText: '메모를 입력하세요',
                    controller: _memoController,
                    useExpanded: false,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: addStore,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff673AB7)),
                            child: const Text('완료',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              cancelDialog(isEdit);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: const Text('취소',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressRow(bool isEdit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Text(
                '주소',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  address.isEmpty ? '주소를 입력해 주세요.' : address,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            if (!isEdit) ...[
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => openAddressDialog(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff673AB7)),
                  child: const Text('주소 검색',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
