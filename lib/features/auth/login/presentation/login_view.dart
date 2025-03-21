import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/auth/login/presentation/login_viewmodel.dart';
import 'package:ip_manager/features/auth/login/presentation/widget/login_text_field.dart';
import 'package:ip_manager/widgets/default_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _pw = TextEditingController();

  void _login() async {
    await ref
        .read(loginViewModelProvider.notifier)
        .login(_id.text.trim(), _pw.text.trim());

    final state = ref.read(loginViewModelProvider);
    state.when(
      data: (isOk) {
        if (isOk) {
          context.replaceNamed('base');
        }
      },
      error: (error, _) {
        _loginFailedDialog('$error');
      },
      loading: () {},
    );
  }

  void _loginFailedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("로그인 실패"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(loginViewModelProvider.notifier);
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          width: Responsive.isMobile(context) ? 370 : 600,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(),
              _subTitle(),
              SizedBox(height: 20),
              LoginTextField(hintText: '아이디', controller: _id),
              SizedBox(height: 20),
              LoginTextField(hintText: '비밀번호', controller: _pw),
              SizedBox(height: 20),
              DefaultButton(
                text: '로그인',
                callback: () {
                  _login();
                },
              ),
              SizedBox(height: 20),
              _signButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signButton() {
    return GestureDetector(
      onTap: () {
        debugPrint("[Flutter] >> 회원가입 버튼");
      },
      child: Center(
        child: Text(
          '회원가입',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _subTitle() {
    return Text(
      '관리자 아이디와 비밀번호를 입력해 주세요.',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _title() {
    return Text(
      'Pc Manager Analyzer',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
