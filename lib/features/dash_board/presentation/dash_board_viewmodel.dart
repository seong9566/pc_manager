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
    await Future.delayed(Duration(milliseconds: 1000));
    await getDashBoardData();
  }

  Future<void> getDashBoardData() async {
    try {
      // 1차 요청
      final DashBoardModel result =
          await dashBoardUseCase.getThisTimeDataList();

      // null 또는 빈 리스트일 경우 예외 발생
      final datas = result.data.datas;
      if (datas.isEmpty) {
        throw Exception("Empty or null data, retrying...");
      }

      // 정상 데이터라면 state 갱신
      state = state.copyWith(dashBoardModel: result);
    } catch (e) {
      debugPrint("[Flutter] >> GetDashBoardData failed, retrying: $e");

      try {
        // 2차 요청 (재시도)
        Future.delayed(Duration(milliseconds: 500));
        final DashBoardModel retryResult =
            await dashBoardUseCase.getThisTimeDataList();

        // 다시 체크
        final retryDatas = retryResult.data.datas;
        if (retryDatas.isEmpty) {
          throw Exception("Retry also returned empty or null data");
        }

        state = state.copyWith(dashBoardModel: retryResult);
      } catch (retryError) {
        // 두 번째 시도도 실패했으면 에러 처리
        debugPrint("[Flutter] >> Retry GetDashBoardData failed: $retryError");
      }
    }
  }

  Future<void> getTopAnalyze() async {
    debugPrint("[Flutter] >> GetTopAnalyze...");
    // 1차 호출 전에 잠깐 딜레이
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // 1차 요청
      final result = await dashBoardUseCase.getTopAnalyze();

      // (Optional) result 검증. 예를 들어 필드가 null 이면 예외 던지기
      // if (result.someField == null) {
      //   throw Exception("Invalid data, retrying...");
      // }

      // 정상이라면 state 갱신
      state = state.copyWith(topAnalyzeModel: result);
    } catch (e) {
      debugPrint("[Flutter] >> GetTopAnalyze failed, retrying: $e");

      try {
        // 2차 요청 전 짧은 딜레이
        await Future.delayed(const Duration(milliseconds: 500));
        final retryResult = await dashBoardUseCase.getTopAnalyze();

        // (Optional) retryResult 검증
        // if (retryResult.someField == null) {
        //   throw Exception("Retry returned invalid data");
        // }

        state = state.copyWith(topAnalyzeModel: retryResult);
      } catch (retryError) {
        // 두 번째 시도도 실패했으면 로그만 남기거나, 필요시 에러 상태 업데이트
        debugPrint("[Flutter] >> Retry GetTopAnalyze failed: $retryError");
        // 예: state = state.copyWith(errorMessage: retryError.toString());
      }
    }
  }
}
