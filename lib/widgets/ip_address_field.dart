import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IPAddressField extends StatefulWidget {
  final TextEditingController controller;
  final bool isReadOnly;
  final String hintText;

  const IPAddressField({
    Key? key,
    required this.controller,
    this.isReadOnly = false,
    this.hintText = 'IP 주소',
  }) : super(key: key);

  @override
  State<IPAddressField> createState() => _IPAddressFieldState();
}

class _IPAddressFieldState extends State<IPAddressField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());

    // 초기값 설정
    _parseInitialValue();

    // 각 컨트롤러의 값이 변경될 때마다 전체 IP 주소 업데이트
    for (var i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        _updateFullIpAddress();
      });
    }
  }
  
  @override
  void didUpdateWidget(IPAddressField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부 컨트롤러의 값이 변경된 경우 내부 필드에 반영
    if (oldWidget.controller.text != widget.controller.text) {
      _parseInitialValue();
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < 4; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  // 초기 IP 주소 값을 파싱하여 각 필드에 설정
  void _parseInitialValue() {
    final initialValue = widget.controller.text;
    if (initialValue.isNotEmpty) {
      final parts = initialValue.split('.');
      for (var i = 0; i < 4; i++) {
        if (i < parts.length) {
          _controllers[i].text = parts[i];
        } else {
          _controllers[i].text = ''; // 비어있는 부분은 빈 문자열로 설정
        }
      }
    } else {
      // 초기값이 없는 경우 모든 필드를 빈 문자열로 설정
      for (var i = 0; i < 4; i++) {
        _controllers[i].text = '';
      }
    }
  }

  // 모든 필드의 값을 합쳐서 전체 IP 주소 업데이트
  void _updateFullIpAddress() {
    final ipParts = _controllers.map((controller) => controller.text).toList();
    widget.controller.text = ipParts.join('.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(7, (index) {
          // 구분자(.)
          if (index % 2 == 1) {
            return const Text(
              '.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          }
          
          // IP 필드
          final fieldIndex = index ~/ 2;
          return Expanded(
            child: TextField(
              controller: _controllers[fieldIndex],
              focusNode: _focusNodes[fieldIndex],
              readOnly: widget.isReadOnly,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 3,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '000',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: widget.isReadOnly ? Colors.grey : Colors.black,
                fontSize: 14,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _OctetInputFormatter(),
              ],
              onChanged: (value) {
                // 3자리 숫자 입력 완료 시 다음 필드로 포커스 이동
                if (value.length == 3 && fieldIndex < 3) {
                  _focusNodes[fieldIndex + 1].requestFocus();
                }
                
                // 빈 필드에서 백스페이스 입력 시 이전 필드로 포커스 이동
                if (value.isEmpty && fieldIndex > 0) {
                  _focusNodes[fieldIndex - 1].requestFocus();
                  // 이전 필드의 커서를 맨 뒤로 이동
                  _controllers[fieldIndex - 1].selection = TextSelection.fromPosition(
                    TextPosition(offset: _controllers[fieldIndex - 1].text.length),
                  );
                }
              },
            ),
          );
        }),
      ),
    );
  }
}

// 0-255 범위의 값만 허용하는 TextInputFormatter
class _OctetInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, 
    TextEditingValue newValue
  ) {
    // 빈 문자열은 허용
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // 숫자만 허용
    if (!RegExp(r'^\d+$').hasMatch(newValue.text)) {
      return oldValue;
    }
    
    // 0으로 시작하는 경우 한 자리 숫자만 허용 (예: 0, 01 -> 1)
    if (newValue.text.startsWith('0') && newValue.text.length > 1) {
      return TextEditingValue(
        text: newValue.text.substring(1),
        selection: TextSelection.collapsed(offset: newValue.text.length - 1),
      );
    }
    
    // 255를 초과하는 값은 255로 제한
    final intValue = int.tryParse(newValue.text) ?? 0;
    if (intValue > 255) {
      return const TextEditingValue(
        text: '255',
        selection: TextSelection.collapsed(offset: 3),
      );
    }
    
    return newValue;
  }
}
