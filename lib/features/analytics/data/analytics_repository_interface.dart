import 'package:ip_manager/model/time_count_model.dart';

import '../../../model/response_model.dart';

abstract class IAnalyticsRepository {
  Future<ResponseModel<List<PcRoomAnalytics>>> getThisDayData({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  });

  Future<ResponseModel<List<PcStatModel>>> getMonthDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  });

  Future<ResponseModel<List<PcStatModel>>> getPeriodList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  });

  Future<ResponseModel<List<PcStatModel>>> getDaysDataList({
    required DateTime targetDate,
    String? pcName,
    int? countryTbId,
    int? townTbId,
    int? cityTbId,
  });
}
