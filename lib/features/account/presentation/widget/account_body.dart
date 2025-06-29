import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/account/presentation/account_viewmodel.dart';
import 'package:ip_manager/features/country/presentation/country_list_provider.dart';

import '../../../../widgets/dot_dialog.dart';
import 'account_table_widget.dart';

class AccountBody extends ConsumerStatefulWidget {
  const AccountBody({super.key});

  @override
  ConsumerState<AccountBody> createState() => _AccountBodyState();
}

class _AccountBodyState extends ConsumerState<AccountBody> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountViewModel).accountModel;
    final cityDropDownItems = ref.watch(countryListProvider);
    if (state.isEmpty) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Expanded(
      child: AccountTable(
        accounts: state,
        // 수정 버튼 누르면
        onEdit: (acc) {
          showEditAccountDialog(
            context,
            title: '계정 수정',
            subTitle: '기존 정보를 수정해주세요',
            cityDropDownItems:
                cityDropDownItems.map((e) => e.countryName).toList(),
            initialUserId: acc.uId,
            initialPassword: null,
            // 보안상 비밀번호는 빈 문자열로 두거나 별도 플로우로 처리
            initialAdminYn: acc.adminYn,
            initialCountryName: acc.countryName,
            onSubmitted: ({
              required userId,
              required password,
              required adminYn,
              required useYn,
              required countryName,
            }) async {
              // if (password.isEmpty) {
              //   showFailedToast(context, "비밀번호를 입력해주세요!");
              //   return;
              // }
              if (countryName.isEmpty) {
                showFailedToast(context, "도시를 선택해주세요!");
                return;
              }

              final ok =
                  await ref.read(accountViewModel.notifier).updateAccount(
                        pId: acc.pId,
                        userId: userId,
                        password: password,
                        adminYn: adminYn,
                        useYn: useYn,
                        countryName: countryName,
                      );
              Navigator.pop(context);
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('계정 수정에 실패했습니다')),
                );
              }
            },
          );
        },
        // 삭제 버튼 누르면
        onDelete: (acc) async {
          /// 서버에 body 값으로 바꿔달라고 요청 해야함.
          final ok =
              await ref.read(accountViewModel.notifier).deleteAccount(acc.pId);
          if (!ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('계정 삭제에 실패했습니다')),
            );
          }
        },
      ),
    );
  }
}
