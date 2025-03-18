import 'package:flutter/material.dart';
import 'package:ip_manager/features/tmp/tmp_controller.dart';

class TmpView extends StatelessWidget {
  const TmpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('기능 테스트 페이지 ')),
      body: Center(
        child: Column(
          children: [
            _textButton("회원 가입", () {
              TmpController().addUser(context, "test", "1234");
            }),
            _textButton("로그인", () {
              TmpController().login(context, "master", "1234");
            }),
            _textButton("유저 확인", () {
              TmpController().checkUserId(context);
            }),
            _textButton("AccountList", () {
              TmpController().accountList(context, 1);
            }),
            _textButton("accountManagement", () {
              TmpController().accountManagement(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _textButton(String title, VoidCallback fn) {
    return TextButton(onPressed: fn, child: Text(title));
  }
}
