import 'package:ip_manager/model/top_analyze_model.dart';

import '../../../model/dash_board_model.dart';

/// InterFace
abstract class IDashBoardRepository {
  Future<DashBoardModel> getThisTimeDataList();

  Future<TopAnalyzeModel> getTopAnalyze();
}
