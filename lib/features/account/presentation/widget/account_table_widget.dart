import 'package:flutter/material.dart';
import 'package:ip_manager/model/account_model.dart';

import '../../../../core/config/screen_size.dart';

/// 계정 테이블 위젯 (반응형: 넓으면 테이블, 좁으면 카드 리스트)
class AccountTable extends StatelessWidget {
  final List<AccountModel> accounts;
  final void Function(AccountModel) onEdit;
  final void Function(AccountModel) onDelete;

  const AccountTable({
    super.key,
    required this.accounts,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 모바일 전환 기준: 폭이 600 이하
        if (Responsive.isMobileLarge(context)) {
          // 카드 형태로 보여주기
          return ListView.separated(
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemBuilder: (context, i) {
              final a = accounts[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('계정: ${a.uId}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('등급: ${a.adminYn ? "Manager" : "Guest"}'),
                      const SizedBox(height: 4),
                      Text('주소: ${a.countryName}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () => onEdit(a),
                            child: const Text('수정',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () => onDelete(a),
                            child: const Text('삭제',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // 기존 테이블 형태
          const headerStyle =
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
          const cellStyle = TextStyle(fontSize: 14);

          return Column(
            children: [
              // 헤더
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: const [
                    Expanded(flex: 2, child: Text('계정', style: headerStyle)),
                    Expanded(flex: 2, child: Text('계정 등급', style: headerStyle)),
                    Expanded(
                        flex: 3, child: Text('계정 할당 주소', style: headerStyle)),
                    Expanded(flex: 2, child: Text('액션', style: headerStyle)),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 리스트
              Expanded(
                child: ListView.separated(
                  itemCount: accounts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final a = accounts[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2, child: Text(a.uId, style: cellStyle)),
                          Expanded(
                              flex: 2,
                              child: Text(a.adminYn ? "Manager" : "Guest",
                                  style: cellStyle)),
                          Expanded(
                              flex: 3,
                              child: Text(a.countryName, style: cellStyle)),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                  ),
                                  onPressed: () => onEdit(a),
                                  child: const Text('수정',
                                      style: TextStyle(fontSize: 14)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                  ),
                                  onPressed: () => onDelete(a),
                                  child: const Text('삭제',
                                      style: TextStyle(fontSize: 14)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
