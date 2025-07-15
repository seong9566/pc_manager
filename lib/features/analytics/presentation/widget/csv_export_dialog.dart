import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ip_manager/constants/colors.dart';
import 'package:ip_manager/model/time_count_model.dart';

class CsvExportDialog extends StatefulWidget {
  final List<PcRoomAnalytics> pcRooms;
  final Function(
          List<int> selectedPcRoomIds, DateTime startDate, DateTime endDate)
      onExport;

  const CsvExportDialog({
    super.key,
    required this.pcRooms,
    required this.onExport,
  });

  @override
  State<CsvExportDialog> createState() => _CsvExportDialogState();
}

class _CsvExportDialogState extends State<CsvExportDialog> {
  // 날짜 범위 상태
  DateTime? _startDate;
  DateTime? _endDate;

  // PC방 선택 상태 (Map<pcRoomId, isSelected>)
  late Map<int, bool> _selectedPcRooms;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();

    // 초기 날짜 범위 설정 (오늘 - 1주일)
    final now = DateTime.now();
    _startDate = now.subtract(const Duration(days: 7));
    _endDate = now;

    // PC방 선택 상태 초기화
    _selectedPcRooms = {
      for (var pcRoom in widget.pcRooms) pcRoom.pcRoomId: false
    };
  }

  // 날짜 범위 선택 함수
  Future<void> _selectDateRange() async {
    // 현재 선택된 날짜 또는 기본값
    final startDate =
        _startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final endDate = _endDate ?? DateTime.now();

    // 컴팩트한 날짜 선택 다이얼로그 표시
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('날짜 범위 선택'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 시작 날짜 선택
              Row(
                children: [
                  const Text('시작일: '),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.purpleColor,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: Text(
                      _startDate != null
                          ? DateFormat('yyyy-MM-dd').format(_startDate!)
                          : '시작일 선택',
                      style: const TextStyle(color: AppColors.purpleColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 종료 날짜 선택
              Row(
                children: [
                  const Text('종료일: '),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: _startDate ?? DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.purpleColor,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                    child: Text(
                      _endDate != null
                          ? DateFormat('yyyy-MM-dd').format(_endDate!)
                          : '종료일 선택',
                      style: const TextStyle(color: AppColors.purpleColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인',
                style: TextStyle(color: AppColors.purpleColor)),
          ),
        ],
      ),
    );
  }

  // '모두 선택' 체크박스 상태 변경
  void _toggleSelectAll(bool? value) {
    if (value == null) return;
    setState(() {
      _selectAll = value;
      // 모든 PC방에 동일한 값 적용
      for (var key in _selectedPcRooms.keys) {
        _selectedPcRooms[key] = value;
      }
    });
  }

  // 개별 PC방 선택 상태 변경
  void _togglePcRoomSelection(int pcRoomId, bool? value) {
    if (value == null) return;
    setState(() {
      _selectedPcRooms[pcRoomId] = value;

      // '모두 선택' 상태 업데이트
      _selectAll = _selectedPcRooms.values.every((v) => v);
    });
  }

  // 선택된 PC방 ID 목록 반환
  List<int> _getSelectedPcRoomIds() {
    return _selectedPcRooms.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // PC방 중복 제거
    final uniquePcRooms = <int, PcRoomAnalytics>{};
    for (var pcRoom in widget.pcRooms) {
      uniquePcRooms[pcRoom.pcRoomId] = pcRoom;
    }

    // 정렬된 PC방 목록
    final sortedPcRooms = uniquePcRooms.values.toList()
      ..sort((a, b) => a.pcRoomName.compareTo(b.pcRoomName));

    // 날짜 범위 텍스트
    final dateFormat = DateFormat('yyyy-MM-dd');
    String dateRangeText;
    if (_startDate != null && _endDate != null) {
      dateRangeText =
          '${dateFormat.format(_startDate!)} ~ ${dateFormat.format(_endDate!)}';
    } else {
      dateRangeText = '날짜 범위를 선택해주세요';
    }

    return AlertDialog(
      title: const Text('CSV 데이터 내보내기'),
      contentPadding:
          const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 16),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 범위 선택 섹션
            const Text('1. 날짜 범위 선택',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(dateRangeText),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // PC방 선택 섹션
            const Text('2. PC방 선택',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // '모두 선택' 체크박스
            CheckboxListTile(
              title: const Text('모두 선택'),
              value: _selectAll,
              onChanged: _toggleSelectAll,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),

            const Divider(),

            // PC방 목록 (스크롤 가능)
            Flexible(
              child: uniquePcRooms.isEmpty
                  ? const Center(child: Text('PC방 목록을 불러오는 중...'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: sortedPcRooms.length,
                      itemBuilder: (context, index) {
                        final pcRoom = sortedPcRooms[index];
                        return CheckboxListTile(
                          title: Text(pcRoom.pcRoomName),
                          subtitle: Text(
                              '${pcRoom.countryName} ${pcRoom.cityName} ${pcRoom.townName}'),
                          value: _selectedPcRooms[pcRoom.pcRoomId] ?? false,
                          onChanged: (value) =>
                              _togglePcRoomSelection(pcRoom.pcRoomId, value),
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              // 취소 버튼 - 크고 눈에 띄게 조정
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12), // 버튼 사이 간격

              // 내보내기 버튼 - 크고 강조되도록 조정
              Expanded(
                flex: 1, // 내보내기 버튼을 더 크게
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purpleColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      final selectedPcRoomIds = _getSelectedPcRoomIds();
                      if (selectedPcRoomIds.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('최소 하나 이상의 PC방을 선택해주세요')),
                        );
                        return;
                      }

                      if (_startDate == null || _endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('날짜 범위를 선택해주세요')),
                        );
                        return;
                      }

                      // 내보내기 콜백 호출
                      widget.onExport(
                          selectedPcRoomIds, _startDate!, _endDate!);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '내보내기',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
