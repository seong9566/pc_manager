import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/core/database/prefs.dart';
import 'package:ip_manager/features/auth/presentation/widget/auth_text_field.dart';
import 'package:ip_manager/provider/user_session.dart';
import 'package:ip_manager/widgets/default_button.dart';

import '../../../core/config/app_colors.dart';
import '../../country/presentation/country_list_provider.dart';
import 'login_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginView>
    with SingleTickerProviderStateMixin {
  bool signClick = false;
  bool signIdError = false;
  bool signPwError = false;
  String? _signErrorText;

  /// Login
  final TextEditingController _id = TextEditingController();
  final TextEditingController _pw = TextEditingController();

  ///Sign
  final TextEditingController _id2 = TextEditingController();
  final TextEditingController _pw2 = TextEditingController();
  final TextEditingController _pwConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    await ref
        .read(loginViewModelProvider.notifier)
        .login(_id.text.trim(), _pw.text.trim());

    final state = ref.read(loginViewModelProvider);
    state.when(
      data: (isOk) async {
        if (isOk) {
          // context.replaceNamed('base');
          String role = await Prefs().getUserRole;
          final session = ref.read(userSessionProvider.notifier);
          session.updateSession(
            role: role,
            isLogin: true, // API 호출로 받은 토큰
          );
          if (mounted) {
            context.goNamed('base');
          }
        }
      },
      error: (error, _) {
        _loginFailedDialog('$error', '로그인 실패');
      },
      loading: () {},
    );
  }

  void _sign() async {
    final password = _pw2.text.trim();
    final confirmPassword = _pwConfirm.text.trim();

    //  비밀번호 유효성 검사
    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        signPwError = true;
        _signErrorText = '비밀번호를 입력해 주세요';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        signPwError = true;
        _signErrorText = '비밀번호가 일치하지 않습니다';
      });
      return;
    }

    setState(() {
      _signErrorText = null;
      signPwError = false;
    });
    await ref
        .read(loginViewModelProvider.notifier)
        .sign(_id2.text.trim(), _pw2.text.trim());

    final state = ref.read(loginViewModelProvider);
    state.when(
      data: (isOk) {
        if (isOk) {
          setState(() {
            signClick = false;
            signIdError = false;
            signPwError = false;
          });
        }
      },
      error: (error, _) {
        setState(() {
          _signErrorText = "아이디가 중복됩니다.";
          signIdError = true;
        });
      },
      loading: () {},
    );
  }

  void _loginFailedDialog(String message, String title) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "LoginFailed",
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
              width: 360,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '로그인 실패',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '아이디 또는 비밀번호를 확인해 주세요.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => context.pop(),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            _loginDialog(context),
            AnimatedOpacity(
              opacity: signClick ? 1.0 : 0.0,
              duration: Duration(milliseconds: 100),
              child: IgnorePointer(
                ignoring: !signClick,
                child: _signDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginDialog(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      width: Responsive.isMobile(context) ? 370 : 600,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(0.0, 0), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          _subTitle(),
          SizedBox(height: 20),
          AuthTextField(hintText: '아이디', controller: _id, obscureText: false),
          SizedBox(height: 20),
          AuthTextField(hintText: '비밀번호', controller: _pw, obscureText: true),
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
    );
  }

  Widget _signDialog(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      width: Responsive.isMobile(context) ? 370 : 600,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(0.0, 0), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          _subTitle(),
          if (signIdError || signPwError)
            Text(
              _signErrorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          SizedBox(height: 20),
          AuthTextField(
              hintText: '아이디',
              controller: _id2,
              error: signIdError,
              obscureText: false),
          SizedBox(height: 20),
          AuthTextField(hintText: '비밀번호', controller: _pw2, obscureText: true),
          SizedBox(height: 20),
          AuthTextField(
            hintText: '비밀번호 확인',
            controller: _pwConfirm,
            error: signPwError,
            obscureText: true,
          ),
          SizedBox(height: 20),
          DefaultButton(
            text: '회원가입',
            callback: () {
              _sign();
            },
          ),
        ],
      ),
    );
  }

  Widget _signButton() {
    return GestureDetector(
      onTap: () {
        debugPrint("[Flutter] >> 회원가입 버튼");
        setState(() {
          signClick = true;
        });
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
