import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/account/presentation/account_viewmodel.dart';

import '../../../../widgets/dot_dialog.dart';
import '../../../../widgets/simple_button.dart';

class AccountHeader extends ConsumerStatefulWidget {
  const AccountHeader({super.key});

  @override
  ConsumerState<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends ConsumerState<AccountHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "이용중인 계정",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        SimpleButton(
            onTap: () {
              setState(() {
                showEditAccountDialog(
                  context,
                  title: "계정 추가",
                  subTitle: "계정 정보를 추가 해주세요.",
                  onSubmitted: ({
                    required userId,
                    required password,
                    required adminYn,
                    required countryName,
                  }) async {
                    final ok =
                        await ref.read(accountViewModel.notifier).addAccount(
                              userId: userId,
                              password: password,
                              adminYn: adminYn,
                              countryName: countryName,
                            );
                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('계정 추가에 실패했습니다')),
                      );
                    }
                  },
                );
              });
            },
            title: '계정 추가'),
      ],
    );
  }
}
