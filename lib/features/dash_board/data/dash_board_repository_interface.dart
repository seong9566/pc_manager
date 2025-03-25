import '../../../model/dash_board_model.dart';

/// InterFace
abstract class IDashBoardRepository {
  Future<DashBoardModel> getThisTimeDataList();
}
