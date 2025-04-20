import 'package:flutter/material.dart';
import 'package:ip_manager/features/account/presentation/widget/account_body.dart';
import 'package:ip_manager/features/account/presentation/widget/account_header.dart';

import '../../../core/config/app_theme.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.only(top: 120, bottom: 12, left: 42, right: 42),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [AppTheme.greyShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountHeader(),
          SizedBox(height: 12),
          AccountBody(),
        ],
      ),
    );
  }
}
