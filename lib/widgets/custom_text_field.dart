import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool? isSubAddress;
  final String hintText;
  final TextEditingController controller;
  final bool? isEdit;
  final bool useExpanded;
  final String? labelText; // 추가: 필드 위에 표시될 제목
  final bool isRequired; // 추가: 필수 입력 항목인지 표시

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isSubAddress = false,
    this.isEdit = false,
    this.useExpanded = true,
    this.labelText, // 옵션: 라벨 텍스트
    this.isRequired = false, // 기본값: 필수 아님
  });

  @override
  Widget build(BuildContext context) {
    // 입력 필드 위젯
    Widget textFieldWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 라벨이 제공된 경우에만 표시
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  labelText!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (isRequired)
                  const Text(
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
        // 입력 필드
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: controller,
            readOnly: isEdit!,
            style: TextStyle(
              color: isEdit! ? Colors.grey : Colors.black,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(left: 12, top: 12),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );

    // useExpanded가 true인 경우에만 Expanded로 감싸기
    return useExpanded ? Expanded(child: textFieldWidget) : textFieldWidget;
  }
}
