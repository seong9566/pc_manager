import 'dart:html' as html;
import 'package:ip_manager/core/database/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ip_manager/core/config/app_version.dart';

/// Flutter 웹 캐시를 관리하는 유틸리티 클래스
/// 앱 버전이 변경될 때마다 캐시를 자동으로 무효화함
class CacheManager {
  static const String _versionKey = 'app_version_cache_key';
  static bool _isCheckingCache = false;

  /// 캐시 무효화 시 호출될 콜백 함수
  static Function? _onCacheInvalidated;

  /// 캐시 유효성 검사 및 필요시 무효화
  /// 웹 플랫폼에서만 동작
  /// [onCacheInvalidated] 캐시 무효화 시 호출될 콜백 함수
  static Future<void> checkCacheValidity({Function? onCacheInvalidated}) async {
    // 콜백 함수 설정
    _onCacheInvalidated = onCacheInvalidated;
    // 이미 체크 중이면 중복 실행 방지
    if (_isCheckingCache) return;

    _isCheckingCache = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedVersion = prefs.getString(_versionKey);
      final currentVersion = AppVersion.cacheKey;

      // 저장된 버전이 없거나 현재 버전과 다른 경우
      if (savedVersion == null || savedVersion != currentVersion) {
        // 새 버전 저장
        await prefs.setString(_versionKey, currentVersion);

        // 이전에 저장된 버전이 있었다면 (첫 실행이 아니라면) 캐시 무효화 및 페이지 리로드
        if (savedVersion != null) {
          _invalidateCache();
        }
      }
    } finally {
      _isCheckingCache = false;
    }
  }

  /// 캐시 무효화 및 페이지 리로드
  static void _invalidateCache() async {
    // 캐시를 무효화
    await Prefs().clear();

    // 콜백 함수가 있으면 호출
    if (_onCacheInvalidated != null) {
      _onCacheInvalidated!();
    }

    // 페이지 리로드
    html.window.location.reload();
  }

  /// 수동으로 캐시 무효화 및 페이지 리로드
  /// [onCacheInvalidated] 캐시 무효화 시 호출될 콜백 함수
  static void forceReload({Function? onCacheInvalidated}) async {
    _onCacheInvalidated = onCacheInvalidated;
    _invalidateCache();
  }
}
