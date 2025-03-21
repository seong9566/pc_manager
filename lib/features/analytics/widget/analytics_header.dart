import 'package:flutter/material.dart';
import 'package:ip_manager/features/analytics/widget/custom_drop_down.dart';

import '../../../widgets/search_text_field.dart';

class AnalyticsHeader extends StatefulWidget {
  const AnalyticsHeader({super.key});

  @override
  State<AnalyticsHeader> createState() => _AnalyticsHeaderState();
}

class _AnalyticsHeaderState extends State<AnalyticsHeader> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 840,
          margin: EdgeInsets.only(right: 24, bottom: 12),
          child: SearchTextField(
            hintText: 'PC방 이름으로 검색',
            controller: _controller,
          ),
        ),
        CustomDropdown(),
      ],
    );
  }
}
