import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/widgets/search_text_field.dart';

class ManagementHeader extends ConsumerStatefulWidget {
  const ManagementHeader({super.key});

  @override
  ConsumerState<ManagementHeader> createState() => _ManagementHeaderState();
}

class _ManagementHeaderState extends ConsumerState<ManagementHeader> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 840,
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: SearchTextField(
            hintText: 'PC방 이름으로 검색',
            controller: _controller,
            onComplete: () {},
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            customButton: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('도시 별로 보기'),
                SizedBox(width: 30),
                Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
              ],
            ),
            items: [
              _dropdownMenuItem("서울"),
              _dropdownMenuItem("부산"),
              _dropdownMenuItem("대구"),
              _dropdownMenuItem("전주"),
              _dropdownMenuItem("대전"),
            ],
            onChanged: (value) {},
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(0, 0),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 드롭다운 아이템 생성 함수
  DropdownMenuItem<String> _dropdownMenuItem(String label) {
    return DropdownMenuItem(
      value: label,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}
