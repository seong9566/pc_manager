import 'package:flutter/material.dart';
import 'package:ip_manager/model/account_model.dart';

/// 계정 테이블 위젯
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
    // 공통 텍스트 스타일
    const headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    const cellStyle = TextStyle(fontSize: 14);

    return Column(
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: const [
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('계정', style: headerStyle))),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('계정 등급', style: headerStyle))),
              Expanded(
                  flex: 3,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('계정 할당 주소', style: headerStyle))),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('액션', style: headerStyle))),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    // 계정 ID
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(a.uId, style: cellStyle),
                      ),
                    ),

                    // 계정 등급
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(a.adminYn == true ? "Manager" : "Guest",
                            style: cellStyle),
                      ),
                    ),

                    // 계정 할당 주소
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,

                        /// TODO 서버에서 준걸로 처리 해야함.
                        child: Text("부산 광역시", style: cellStyle),
                      ),
                    ),

                    // 액션 버튼
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
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
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
