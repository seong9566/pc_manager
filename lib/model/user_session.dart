class UserSession {
  UserSession._internal();

  static final UserSession instance = UserSession._internal();

  String? role;
  String? token;

  /// 로그인 성공 시 세션 설정
  void setSession({required String role, required String token}) {
    this.role = role;
    this.token = token;
  }

  /// 역할만 업데이트
  void setRole(String role) {
    this.role = role;
  }

  /// 토큰만 업데이트
  void setToken(String token) {
    this.token = token;
  }

  /// 세션 초기화 (로그아웃)
  void clear() {
    role = null;
    token = null;
  }

  /// 로그인 여부
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
