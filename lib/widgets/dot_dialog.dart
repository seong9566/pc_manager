import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../core/config/app_colors.dart';
import '../features/analytics/presentation/analytics_viewmodel.dart';
import '../provider/date_provider.dart';

final cityDropDownItems = <String>[
  '서울특별시',
  '부산광역시',
  '대구광역시',
  '인천광역시',
  '광주광역시',
  '대전광역시',
  '울산광역시',
  '세종특별자치시',
  '경기도',
  '강원도',
  '충청북도',
  '충청남도',
  '전라북도',
  '전라남도',
  '경상북도',
  '경상남도',
  '제주특별자치도',
];
// final cityDropDownItems = [

// DropdownMenuItem(value: '서울특별시', child: Text('서울특별시')),
// DropdownMenuItem(value: '부산광역시', child: Text('부산광역시')),
// DropdownMenuItem(value: '대구광역시', child: Text('대구광역시')),
// DropdownMenuItem(value: '인천광역시', child: Text('인천광역시')),
// DropdownMenuItem(value: '광주광역시', child: Text('광주광역시')),
// DropdownMenuItem(value: '대전광역시', child: Text('대전광역시')),
// DropdownMenuItem(value: '울산광역시', child: Text('울산광역시')),
// DropdownMenuItem(value: '세종특별자치시', child: Text('세종특별자치시')),
// DropdownMenuItem(value: '경기도', child: Text('경기도')),
// DropdownMenuItem(value: '강원도', child: Text('강원도')),
// DropdownMenuItem(value: '충청북도', child: Text('충청북도')),
// DropdownMenuItem(value: '충청남도', child: Text('충청남도')),
// DropdownMenuItem(value: '전라북도', child: Text('전라북도')),
// DropdownMenuItem(value: '전라남도', child: Text('전라남도')),
// DropdownMenuItem(value: '경상북도', child: Text('경상북도')),
// DropdownMenuItem(value: '경상남도', child: Text('경상남도')),
// DropdownMenuItem(value: '제주특별자치도', child: Text('제주특별자치도')),
// ];

Future<void> showAnalyticsDatePicker({
  required BuildContext context,
  required WidgetRef ref,
  required AnalyticsType type,
  DateTime? periodStart,
  DateTime? periodEnd,
  required void Function(DateTime) onDaySelected,
  required void Function(DateTime, DateTime) onRangeSelected,
  required void Function(DateTime) onMonthSelected,
}) {
  // 탭별 초기 날짜 가져오기
  final dateState = ref.read(dateViewModel);
  DateTime initialDate;
  switch (type) {
    case AnalyticsType.all:
      initialDate = dateState.allDate;
      break;
    case AnalyticsType.daily:
      initialDate = dateState.dailyDate;
      break;
    case AnalyticsType.monthly:
      initialDate = dateState.monthlyDate;
      break;
    case AnalyticsType.period:
      // 기간 모드는 Single 모드가 아니기에, 초기 날짜는 편의상 시작일 또는 오늘로
      initialDate = periodStart ?? DateTime.now();
      break;
  }

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: SizedBox(
        width: 300,
        height: type == AnalyticsType.monthly ? 350 : 400,
        child: SfDateRangePicker(
          showActionButtons: true,
          confirmText: '확인',
          cancelText: '닫기',
          onCancel: () => Navigator.pop(context),
          onSubmit: (args) {
            switch (type) {
              case AnalyticsType.monthly:
                final dt = args as DateTime;
                onMonthSelected(DateTime(dt.year, dt.month));
                break;
              case AnalyticsType.period:
                final range = args as PickerDateRange;
                if (range.startDate != null && range.endDate != null) {
                  onRangeSelected(range.startDate!, range.endDate!);
                }
                break;
              case AnalyticsType.daily:
              case AnalyticsType.all:
                final date = args as DateTime;
                onDaySelected(date);
                break;
            }
            Navigator.pop(context);
          },
          allowViewNavigation: type != AnalyticsType.monthly,
          view: type == AnalyticsType.monthly
              ? DateRangePickerView.year
              : DateRangePickerView.month,
          selectionMode: type == AnalyticsType.period
              ? DateRangePickerSelectionMode.range
              : DateRangePickerSelectionMode.single,
          // 탭별로 분리된 초기 선택값
          initialSelectedDate:
              (type == AnalyticsType.period) ? null : initialDate,
          initialSelectedRange: (type == AnalyticsType.period &&
                  periodStart != null &&
                  periodEnd != null)
              ? PickerDateRange(periodStart, periodEnd)
              : null,
        ),
      ),
    ),
  );
}

Future<void> showEditAccountDialog(
  BuildContext context, {
  required String title,
  required String subTitle,
  String? initialUserId,
  String? initialPassword,
  bool? initialAdminYn, // true→Manager, false→Guest
  String? initialCountryName,
  bool? initialUseYn, // true→사용, false→미사용
  required Function({
    required String userId,
    required String password,
    required bool adminYn,
    required String countryName,
    required bool useYn,
  }) onSubmitted,
}) {
  final idController = TextEditingController(text: initialUserId ?? '');
  final pwController = TextEditingController(text: initialPassword ?? '');
  final pwConfirmController =
      TextEditingController(text: initialPassword ?? '');

  bool isManager = initialAdminYn == true;
  bool isGuest = initialAdminYn == false && initialAdminYn != null;
  bool isUse = initialUseYn ?? true;
  String? selectedCity = initialCountryName;

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (ctx, anim1, anim2) {
      final mq = MediaQuery.of(ctx);
      final isMobile = Responsive.isMobileLarge(context);
      final dialogWidth = mq.size.width * (isMobile ? 0.9 : 0.4);

      return Center(
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: mq.size.height * 0.9,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (ctx, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목
                        Text(title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(subTitle,
                            style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 16),

                        // ID
                        TextField(
                          controller: idController,
                          decoration: _buildDecoration('계정 ID'),
                        ),
                        const SizedBox(height: 12),

                        // PW
                        TextField(
                          controller: pwController,
                          obscureText: true,
                          decoration: _buildDecoration('비밀번호'),
                        ),
                        const SizedBox(height: 12),

                        // PW 확인
                        TextField(
                          controller: pwConfirmController,
                          obscureText: true,
                          decoration: _buildDecoration('비밀번호 확인'),
                        ),
                        const SizedBox(height: 16),

                        // Manager / Guest
                        Row(
                          children: [
                            _buildCheckbox(
                              label: 'Manager',
                              value: isManager,
                              onChanged: (v) => setState(() {
                                isManager = v!;
                                isGuest = !v;
                              }),
                            ),
                            const SizedBox(width: 16),
                            _buildCheckbox(
                              label: 'Guest',
                              value: isGuest,
                              onChanged: (v) => setState(() {
                                isGuest = v!;
                                isManager = !v;
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 사용 여부
                        Row(
                          children: [
                            _buildCheckbox(
                              label: '사용',
                              value: isUse,
                              onChanged: (v) => setState(() {
                                isUse = v!;
                              }),
                            ),
                            const SizedBox(width: 16),
                            _buildCheckbox(
                              label: '미사용',
                              value: !isUse,
                              onChanged: (v) => setState(() {
                                isUse = !v!;
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 도시 선택
                        DropdownSearch<String>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            constraints: const BoxConstraints(maxHeight: 250),
                          ),
                          items: cityDropDownItems,
                          selectedItem: selectedCity,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration:
                                _buildDecoration('시·도 선택'),
                          ),
                          onChanged: (v) => setState(() => selectedCity = v),
                        ),
                        const SizedBox(height: 24),

                        // 완 료 버튼
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purpleColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              onSubmitted(
                                userId: idController.text,
                                password: pwController.text,
                                adminYn: isManager,
                                countryName: selectedCity ?? '',
                                useYn: isUse,
                              );
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('입력 완료',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

/// 공통 InputDecoration 빌더
InputDecoration _buildDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.greyColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.purpleColor),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

/// 공통 Checkbox + Label
Widget _buildCheckbox({
  required String label,
  required bool value,
  required ValueChanged<bool?> onChanged,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
        checkColor: AppColors.purpleColor,
        fillColor: WidgetStateProperty.all(Colors.white),
        side: WidgetStateBorderSide.resolveWith((s) => BorderSide(
            color: s.contains(WidgetState.selected)
                ? AppColors.purpleColor
                : AppColors.greyColor,
            width: 2)),
      ),
      Text(label,
          style: TextStyle(color: value ? AppColors.purpleColor : Colors.grey)),
    ],
  );
}
