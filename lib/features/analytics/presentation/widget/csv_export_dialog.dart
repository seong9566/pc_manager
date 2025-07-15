import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ip_manager/constants/colors.dart';
import 'package:ip_manager/model/time_count_model.dart';

/// CSV 내보내기 다이얼로그
class CsvExportDialog extends StatefulWidget {
  final List<PcRoomAnalytics> pcRooms;
  final Function(List<int>, DateTime, DateTime) onExport;

  const CsvExportDialog({
    super.key,
    required this.pcRooms,
    required this.onExport,
  });

  @override
  State<CsvExportDialog> createState() => _CsvExportDialogState();
}

class _CsvExportDialogState extends State<CsvExportDialog> {
  // 날짜 변수를 non-nullable로 변경하고 초기값 설정
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  final Map<String, bool> _selectedPcRooms = {};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    // PC방 선택 상태 초기화
    for (var pcRoom in widget.pcRooms) {
      _selectedPcRooms[pcRoom.pcRoomId.toString()] = false;
    }
  }

  void _selectDateRange() {
    // 임시 날짜 변수 (다이얼로그 내부 상태용)
    DateTime tempStartDate = _startDate;
    DateTime tempEndDate = _endDate;

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder로 다이얼로그 내부 상태 관리
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('날짜 범위 선택'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 시작일 선택
                  ListTile(
                    title: Text(
                      DateFormat('yyyy-MM-dd').format(tempStartDate),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempStartDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (picked != null) {
                        // 다이얼로그 내부 상태 업데이트
                        setDialogState(() {
                          tempStartDate = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  // 종료일 선택
                  ListTile(
                    title: Text(
                      DateFormat('yyyy-MM-dd').format(tempEndDate),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempEndDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (picked != null) {
                        // 다이얼로그 내부 상태 업데이트
                        setDialogState(() {
                          tempEndDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    // 메인 다이얼로그의 상태 업데이트
                    setState(() {
                      _startDate = tempStartDate;
                      _endDate = tempEndDate;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      // 모든 PC방 선택/해제
      for (var pcRoom in widget.pcRooms) {
        _selectedPcRooms[pcRoom.pcRoomId.toString()] = _selectAll;
      }
    });
  }

  void _togglePcRoomSelection(String id, bool? value) {
    setState(() {
      _selectedPcRooms[id] = value ?? false;
      // 모든 PC방이 선택되었는지 확인하여 전체 선택 상태 업데이트
      _selectAll = _selectedPcRooms.values.every((selected) => selected);
    });
  }

  List<int> _getSelectedPcRoomIds() {
    return _selectedPcRooms.entries
        .where((entry) => entry.value)
        .map((entry) => int.parse(entry.key))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              const Center(
                child: Text(
                  'CSV 내보내기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 24),

              // 날짜 범위 선택 섹션
              const Text(
                '날짜 범위 선택',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDateRange,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${DateFormat('yyyy-MM-dd').format(_startDate)} ~ ${DateFormat('yyyy-MM-dd').format(_endDate)}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // PC방 선택 섹션
              const Text(
                'PC방 선택',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // 전체 선택 체크박스
              CheckboxListTile(
                title: const Text('전체 선택'),
                value: _selectAll,
                onChanged: _toggleSelectAll,
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
              const Divider(height: 8),

              // PC방 목록
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: widget.pcRooms.isEmpty
                    ? const Center(child: Text('선택할 PC방이 없습니다.'))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.pcRooms.length,
                        itemBuilder: (context, index) {
                          final pcRoom = widget.pcRooms[index];
                          return CheckboxListTile(
                            title: Text(pcRoom.pcRoomName),
                            value:
                                _selectedPcRooms[pcRoom.pcRoomId.toString()] ??
                                    false,
                            onChanged: (value) => _togglePcRoomSelection(
                                pcRoom.pcRoomId.toString(), value),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // 버튼 영역
              Row(
                children: [
                  // 취소 버튼
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('취소'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 내보내기 버튼
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final selectedPcRoomIds = _getSelectedPcRoomIds();
                          if (selectedPcRoomIds.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('최소 하나 이상의 PC방을 선택해주세요')),
                            );
                            return;
                          }

                          // 날짜 유효성 검사
                          if (_startDate.isAfter(_endDate)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('시작일은 종료일보다 이전이어야 합니다')),
                            );
                            return;
                          }

                          // 내보내기 콜백 호출
                          widget.onExport(
                              selectedPcRoomIds, _startDate, _endDate);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purpleColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '내보내기',
                          style: TextStyle(color: Colors.white),
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
  }
}
