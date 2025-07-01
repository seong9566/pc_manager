import '../../../model/region_info_model.dart';

/// 지역 정보 리포지토리 인터페이스
abstract class IRegionRepository {
  /// 지역 정보 데이터를 가져옵니다.
  Future<RegionInfoModel> getRegionInfo();
}
