import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/dash_board_model.dart';
import '../domain/dash_board_use_case.dart';

/**
 * AsyncValue : 데이터 통신을 하고 비동기 데이터를 관리 하기 위함.
 * loading, success, error를 하나의 타입으로 관리가 가능 하기 때문.
 */
final dashBoardViewModelProvider =
    StateNotifierProvider<DashBoardViewModel, AsyncValue<DashBoardModel>>((
      ref,
    ) {
      return DashBoardViewModel(ref.read(dashBoardUseCaseProvider));
    });

class DashBoardViewModel extends StateNotifier<AsyncValue<DashBoardModel>> {
  final DashBoardUseCase dashBoardUseCase;

  DashBoardViewModel(this.dashBoardUseCase) : super(const AsyncLoading()) {
    getDashBoardData();
  }

  Future<void> getDashBoardData() async {
    try {
      final result = await dashBoardUseCase.getThisTimeDataList();
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
