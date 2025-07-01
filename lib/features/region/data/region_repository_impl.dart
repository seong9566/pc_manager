import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/region_info_model.dart';
import '../../../model/response_model.dart';
import 'region_repository_interface.dart';
import 'region_service.dart';

/// 지역 정보 리포지토리 구현체 Provider
final regionRepositoryProvider = Provider<IRegionRepository>((ref) {
  return RegionRepositoryImpl(ref.read(regionServiceProvider));
});

/// 지역 정보 리포지토리 구현체
class RegionRepositoryImpl implements IRegionRepository {
  final RegionService _service;

  RegionRepositoryImpl(this._service);

  @override
  Future<RegionInfoModel> getRegionInfo() async {
    try {
      final response = await _service.getRegionInfo();
      
      // ResponseModel을 통해 데이터 파싱
      final parsed = ResponseModel<List<dynamic>>.fromJson(
        response.data,
        (json) => (json as List).cast<Map<String, dynamic>>(),
      );
      
      // RegionInfoModel로 변환
      return RegionInfoModel.fromJson(parsed.data);
    } catch (e) {
      // 에러 발생 시 빈 모델 반환
      return RegionInfoModel();
    }
  }
}
