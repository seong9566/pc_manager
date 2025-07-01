import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:ip_manager/core/config/screen_size.dart';
import 'package:ip_manager/core/database/prefs.dart';
import 'package:ip_manager/features/auth/presentation/widget/auth_text_field.dart';
import 'package:ip_manager/provider/user_session.dart';
import 'package:ip_manager/widgets/default_button.dart';
import 'package:ip_manager/core/utils/cache_manager.dart';

import '../../../core/config/app_colors.dart';
import 'login_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginView>
    with SingleTickerProviderStateMixin {
  /// Login
  final TextEditingController _id = TextEditingController();
  final TextEditingController _pw = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 웹 플랫폼에서만 캐시 유효성 검사 수행
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 로그인 화면에서 캐시 체크 수행
        CacheManager.checkCacheValidity();
      });
    }
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
                    // height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => context.pop(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
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
        child: _loginDialog(context),
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



  Widget _signButton() {
    return GestureDetector(
      onTap: () {
        debugPrint("[Flutter] >> 회원가입 버튼");
        context.goNamed('signup');
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
