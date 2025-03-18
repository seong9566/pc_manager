import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static final PreferencesHelper _chatUtil = PreferencesHelper._internal();

  factory PreferencesHelper() {
    return _chatUtil;
  }

  PreferencesHelper._internal();

  Future<bool> getBool(String key) async {
    final p = await prefs;
    return p.getBool(key) ?? false;
  }

  Future setBool(String key, bool value) async {
    final p = await prefs;
    return p.setBool(key, value);
  }

  Future<int> getInt(String key) async {
    final p = await prefs;
    return p.getInt(key) ?? 0;
  }

  Future setInt(String key, int value) async {
    final p = await prefs;
    return p.setInt(key, value);
  }

  Future<String> getString(String key) async {
    final p = await prefs;
    return p.getString(key) ?? '';
  }

  Future setString(String key, String value) async {
    final p = await prefs;
    return p.setString(key, value);
  }

  Future<List<String>> getStrings(String key) async {
    final p = await prefs;
    return p.getStringList(key) ?? List.empty();
  }

  Future setStrings(String key, List<String> value) async {
    final p = await prefs;
    return p.setStringList(key, value);
  }

  Future<double> getDouble(String key) async {
    final p = await prefs;
    return p.getDouble(key) ?? 0.0;
  }

  Future setDouble(String key, double value) async {
    final p = await prefs;
    return p.setDouble(key, value);
  }

  Future clearPrefs() async {
    final p = await prefs;
    p.clear();
  }

  // helper
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
