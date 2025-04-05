import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/domain/management_use_case.dart';
import 'package:ip_manager/model/management_model.dart';
import 'package:ip_manager/model/response_model.dart';

/**
 *
 * ViewModel의 역할 : UI 이벤트를 받아서 UseCase를 호출하는 역할 (presentation logic만 가짐)
 *
 * AsyncValue : 데이터 통신을 하고 비동기 데이터를 관리 하기 위함.
 * loading, success, error를 하나의 타입으로 관리가 가능 하기 때문.
 *
 */
final managementViewModelProvider = StateNotifierProvider<ManagementViewModel,
    AsyncValue<List<ManagementModel>>>((ref) {
  return ManagementViewModel(ref.read(managementUseCaseProvider));
});

class ManagementViewModel
    extends StateNotifier<AsyncValue<List<ManagementModel>>> {
  final ManagementUseCase managementUseCase;

  ManagementViewModel(this.managementUseCase) : super(const AsyncLoading()) {
    getStoreList();
  }

  Future<void> getStoreList({String? pcName}) async {
    try {
      List<ManagementModel> result;
      // result = await managementUseCase.getStoreList(pcName);
      // state = AsyncValue.data(result);
      Future.delayed(Duration(milliseconds: 1000)).then((_) async {
        result = await managementUseCase.getStoreList(pcName);
        state = AsyncValue.data(result);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> getStoreSearchName(String name) async {
    state = const AsyncLoading();

    try {
      final result = await managementUseCase.searchStoreByName(name);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<ResponseModel?> addStore({
    required String ip,
    required int port,
    required String name,
    required String addr,
    required int seatNumber,
    required double price,
    required double pricePercent,
    required String countryName,
    required String cityName,
    required String townName,
    String? pcSpec,
    String? telecom,
    String? memo,
  }) async {
    final result = await managementUseCase.addStore(
        ip: ip,
        port: port,
        name: name,
        addr: addr,
        seatNumber: seatNumber,
        price: price,
        pricePercent: pricePercent,
        countryName: countryName,
        cityName: cityName,
        townName: townName,
        pcSpec: pcSpec,
        telecom: telecom,
        memo: memo);
    if (result!.code != 200) {
      debugPrint("[Flutter] >> Store Add Failed Server Error!");
    }

    debugPrint("[Flutter] >> result : ${result!.data}");
    debugPrint("[Flutter] >> result : ${result.message}");
    debugPrint("[Flutter] >> result : ${result.code}");
    return result;
  }
}
