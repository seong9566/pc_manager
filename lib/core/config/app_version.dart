import 'package:flutter/foundation.dart';

/// 앱 버전 정보를 관리하는 클래스
/// 빌드 타임스탬프를 사용하여 매 빌드마다 자동으로 버전이 변경됨
class AppVersion {
  /// 현재 웹 플랫폼에서 실행 중인지 여부
  static final bool isWeb = kIsWeb;

  /// 앱 버전 - 수동으로 업데이트
  static const String version = '1.3.0';

  /// 캐시 무효화를 위한 고유 키
  /// 빌드 타임스탬프와 버전을 조합하여 생성
  static String get cacheKey => version;
}
