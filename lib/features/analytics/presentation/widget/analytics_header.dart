import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/search_text_field.dart';
import 'custom_drop_down.dart';

class AnalyticsHeader extends ConsumerStatefulWidget {
  const AnalyticsHeader({super.key});

  @override
  ConsumerState<AnalyticsHeader> createState() => _AnalyticsHeaderState();
}

class _AnalyticsHeaderState extends ConsumerState<AnalyticsHeader> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 600,
          margin: EdgeInsets.only(right: 24, bottom: 12),
          child: SearchTextField(
            hintText: 'PC방 이름으로 검색',
            controller: _controller,
            onComplete: () {},
          ),
        ),
        CustomDropdown(),
      ],
    );
  }
}
