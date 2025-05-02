import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/presentation/widget/management_body.dart';
import 'package:ip_manager/features/management/presentation/widget/management_header.dart';

import '../../../core/config/screen_size.dart';
import '../../country/presentation/country_list_provider.dart';

class ManagementView extends ConsumerStatefulWidget {
  const ManagementView({super.key});

  @override
  ConsumerState<ManagementView> createState() => _ManagementViewState();
}

class _ManagementViewState extends ConsumerState<ManagementView> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(countryListProvider.notifier).init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Responsive.isDesktop(context) ? 40 : 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ManagementHeader()),
        ManagementBody()
      ],
    );
  }
}
