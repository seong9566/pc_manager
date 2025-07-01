import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/features/auth/presentation/widget/auth_text_field.dart';
import 'package:ip_manager/widgets/default_button.dart';

import 'login_viewmodel.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  bool signIdError = false;
  bool signPwError = false;
  String? _signErrorText;

  final TextEditingController _id = TextEditingController();
  final TextEditingController _pw = TextEditingController();
  final TextEditingController _pwConfirm = TextEditingController();

  void _sign() async {
    final password = _pw.text.trim();
    final confirmPassword = _pwConfirm.text.trim();

    // 비밀번호 유효성 검사
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
        .sign(_id.text.trim(), _pw.text.trim());

    final state = ref.read(loginViewModelProvider);
    state.when(
      data: (isOk) {
        if (isOk) {
          // 회원가입 성공 시 로그인 페이지로 이동
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인해주세요.')),
            );
            context.go('/');
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _signupContainer(context),
      ),
    );
  }

  Widget _signupContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      width: Responsive.isMobile(context) ? 370 : 600,
      height: 450, // 뒤로가기 버튼을 위해 높이 약간 증가
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: const [
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
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 20),
          AuthTextField(
            hintText: '아이디',
            controller: _id,
            error: signIdError,
            obscureText: false,
          ),
          const SizedBox(height: 20),
          AuthTextField(
            hintText: '비밀번호',
            controller: _pw,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          AuthTextField(
            hintText: '비밀번호 확인',
            controller: _pwConfirm,
            error: signPwError,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          DefaultButton(
            text: '회원가입',
            callback: () {
              _sign();
            },
          ),
          // const SizedBox(height: 20),
          // _backButton(),
        ],
      ),
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () {
        context.go('/'); // 로그인 페이지로 이동
      },
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.arrow_back,
              size: 16,
              color: Colors.grey,
            ),
            SizedBox(width: 4),
            Text(
              '로그인으로 돌아가기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subTitle() {
    return const Text(
      '회원가입을 위한 정보를 입력해 주세요.',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Pc Manager Analyzer',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}


