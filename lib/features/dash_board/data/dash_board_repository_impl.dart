import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/dash_board/data/dash_board_repository_interface.dart';
import 'package:ip_manager/model/top_analyze_model.dart';

import '../../../model/dash_board_model.dart';
import 'dash_board_service.dart';

/// Repository 의 구현체를 주입
final dashBoardRepositoryProvider = Provider<IDashBoardRepository>((ref) {
  return DashBoardRepositoryImpl(ref.read(dashBoardServiceProvider));
});

class DashBoardRepositoryImpl implements IDashBoardRepository {
  final DashBoardService dashBoardService;

  DashBoardRepositoryImpl(this.dashBoardService);

  @override
  Future<DashBoardModel> getThisTimeDataList() async {
    final response = await dashBoardService.getThisTimeDataList();
    return DashBoardModel.fromJson(response.data);
  }

  @override
  Future<TopAnalyzeModel> getTopAnalyze() async {
    final response = await dashBoardService.getTopAnalyze();
    final data = TopAnalyzeModel.fromJson(response.data['data']);
    return data;
  }
}
