import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'region_info_provider.dart';

/// 앱 시작 시 지역 정보 데이터를 초기화하는 Provider
final regionInfoInitializerProvider = Provider<RegionInfoInitializer>((ref) {
  return RegionInfoInitializer(ref);
});

class RegionInfoInitializer {
  final ProviderRef _ref;

  RegionInfoInitializer(this._ref);

  /// 지역 정보 데이터 초기화
  Future<void> initialize() async {
    await _ref.read(regionInfoProvider.notifier).init();
  }
}
