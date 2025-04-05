import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/dash_board_model.dart';
import '../../../model/top_analyze_model.dart';
import '../domain/dash_board_use_case.dart';

class DashBoardState {
  final DashBoardModel? dashBoardModel;
  final TopAnalyzeModel? topAnalyzeModel;

  DashBoardState({this.dashBoardModel, this.topAnalyzeModel});

  DashBoardState copyWith({
    DashBoardModel? dashBoardModel,
    TopAnalyzeModel? topAnalyzeModel,
  }) {
    return DashBoardState(
      dashBoardModel: dashBoardModel ?? this.dashBoardModel,
      topAnalyzeModel: topAnalyzeModel ?? this.topAnalyzeModel,
    );
  }
}

/**
 * AsyncValue : 데이터 통신을 하고 비동기 데이터를 관리 하기 위함.
 * loading, success, error를 하나의 타입으로 관리가 가능 하기 때문.
 */
final dashBoardViewModelProvider =
    StateNotifierProvider<DashBoardViewModel, DashBoardState>((ref) {
  return DashBoardViewModel(ref.read(dashBoardUseCaseProvider));
});

class DashBoardViewModel extends StateNotifier<DashBoardState> {
  final DashBoardUseCase dashBoardUseCase;

  DashBoardViewModel(this.dashBoardUseCase) : super(DashBoardState()) {
    _init();
  }

  Future<void> _init() async {
    await getTopAnalyze();

    /// 데이터 한번에 요청 하면 DB 에서 트랜잭션 이유 때문인지.. 데이터를 넘겨주지 않음
    await Future.delayed(Duration(milliseconds: 1500));
    await getDashBoardData();
  }

  Future<void> getDashBoardData() async {
    debugPrint("[Flutter] >> GetDashBoardData...");
    try {
      final result = await dashBoardUseCase.getThisTimeDataList();
      state = state.copyWith(dashBoardModel: result);
    } catch (e) {
      debugPrint("[Flutter] >> GetDashBoardData Error : $e");
    }
  }

  Future<void> getTopAnalyze() async {
    debugPrint("[Flutter] >> GetTopAnalyze...");
    try {
      final result = await dashBoardUseCase.getTopAnalyze();
      state = state.copyWith(topAnalyzeModel: result);
    } catch (e) {
      debugPrint("[Flutter] >>  GetTopAnalyze error : $e");
    }
  }
}
