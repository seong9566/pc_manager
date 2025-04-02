import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/model/dash_board_model.dart';
import 'package:ip_manager/model/top_analyze_model.dart';

import '../data/dash_board_repository_impl.dart';
import '../data/dash_board_repository_interface.dart';

/// 의존 역전 원칙에 의해 UseCase는 Interface만 알고 있음
/// 실제로 어떤 구현체가 들어올지는 Provider로 의존성 주입으로 알게된다.
final dashBoardUseCaseProvider = Provider<DashBoardUseCase>((ref) {
  return DashBoardUseCase(ref.read(dashBoardRepositoryProvider));
});

class DashBoardUseCase {
  /// Provider의 의존성 주입으로 인해 Interface를 생성해도 구현체가 동작하게 됌.
  final IDashBoardRepository dashBoardRepository;

  DashBoardUseCase(this.dashBoardRepository);

  Future<DashBoardModel> getThisTimeDataList() async {
    return await dashBoardRepository.getThisTimeDataList();
  }

  Future<TopAnalyzeModel> getTopAnalyze() async {
    return await dashBoardRepository.getTopAnalyze();
  }
}
