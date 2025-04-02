import 'package:ip_manager/core/database/prefrences_helper.dart';

class Prefs {
  static final Prefs _prefs = Prefs._internal();

  factory Prefs() {
    return _prefs;
  }

  Prefs._internal();

  /// 로그인 -> 토큰 저장 -> 다음 로그인에서 해당 토큰으로 api요청
  Future<String> get getToken => PreferencesHelper().getString('token');

  Future setToken(String token) =>
      PreferencesHelper().setString('token', token);

  Future setUserRole(String role) =>
      PreferencesHelper().setString('role', role);

  Future<String> get getUserRole => PreferencesHelper().getString('role');

  Future<bool> get isAutoLogin => PreferencesHelper().getBool('autoLogin');

  Future setIsAutoLogin(bool isAutoLogin) =>
      PreferencesHelper().setBool('autoLogin', isAutoLogin);
}
