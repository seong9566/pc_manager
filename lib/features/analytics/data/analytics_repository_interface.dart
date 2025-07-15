import 'package:ip_manager/model/time_count_model.dart';
import 'models/excel_data_model.dart';

import '../../../model/response_model.dart';

abstract class IAnalyticsRepository {
  Future<ExcelDataResponse> getExcelData({
    required DateTime startDate,
    required DateTime endDate,
    required List<int> pcId,
  });

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
    required DateTime startDate,
    required DateTime endDate,
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
