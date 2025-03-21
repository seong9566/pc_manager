import 'package:flutter/material.dart';
import 'package:ip_manager/features/management/presentation/widget/management_body.dart';
import 'package:ip_manager/features/management/presentation/widget/management_header.dart';

class ManagementView extends StatelessWidget {
  const ManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [SizedBox(height: 40), ManagementHeader(), ManagementBody()],
    );
  }
}
