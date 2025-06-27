import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/domain/management_use_case.dart';
import 'package:ip_manager/model/management_model.dart';
import 'package:ip_manager/model/response_model.dart';

import '../../../model/ping_model.dart';

///
/// ViewModel의 역할 : UI 이벤트를 받아서 UseCase를 호출하는 역할 (presentation logic만 가짐)
///
/// AsyncValue : 데이터 통신을 하고 비동기 데이터를 관리 하기 위함.
/// loading, success, error를 하나의 타입으로 관리가 가능 하기 때문.
///

class ManagementViewModel
    extends StateNotifier<AsyncValue<List<ManagementModel>>> {
  final ManagementUseCase managementUseCase;

  ManagementViewModel(this.managementUseCase) : super(const AsyncLoading()) {
    getStoreList();
  }

  // 원본을 보관할 내부 변수
  List<ManagementModel> originAllStores = [];

  Future<void> getStoreList({String? pcName}) async {
    try {
      // result = await managementUseCase.getStoreList(pcName);
      // state = AsyncValue.data(result);
      Future.delayed(Duration(milliseconds: 1000)).then((_) async {
        originAllStores = await managementUseCase.getStoreList(pcName);
        state = AsyncValue.data(originAllStores);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Local State 에서 검색
  /// PC 이 름으로 검색
  /// 키 입력마다 바로 호출: 빈 문자열이면 _allStores 전체, 아니면 contains 필터
  void searchStoreName({required String name}) {
    state = AsyncValue.loading();

    final filtered = name.isEmpty
        ? originAllStores
        : originAllStores.where((m) => m.name!.contains(name)).toList();

    // Future.delayed(Duration(milliseconds: 1000));
    state = AsyncValue.data(filtered);
  }

  Future<void> getCountryStoreList({required int countryId}) async {
    state = const AsyncLoading();
    try {
      final allStores =
          await managementUseCase.getCountryStoreList(countryId: countryId);
      state = AsyncValue.data(allStores);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// API 요청
  // Future<void> getStoreSearchName(String name) async {
  //   state = const AsyncLoading();
  //
  //   try {
  //     final result = await managementUseCase.searchStoreByName(name);
  //     state = AsyncValue.data(result);
  //   } catch (e, stack) {
  //     state = AsyncValue.error(e, stack);
  //   }
  // }

  Future<PingModel?> sendIpPing({required int pId}) async {
    try {
      final result = await managementUseCase.sendIpPing(pId: pId);
      if (result.code != 200) {
        debugPrint(
            "[Flutter] >> sendIpPing failed, server returned code ${result.code}");
        return null;
      }
      return PingModel(used: result.data.used, unUsed: result.data.unUsed);
    } catch (e, st) {
      debugPrint("[Flutter] >> sendIpPing exception: $e\n$st");
      return null;
    }
  }

  /// 권한 : Master
  Future<ResponseModel?> deleteStore({required int pId}) async {
    final result = await managementUseCase.deleteStore(pId: pId);
    final previous = state;
    state =
        AsyncValue.data([...state.value!..removeWhere((e) => e.pId == pId)]);
    debugPrint("[Flutter] >> result: $result");
    if (result.code != 200) {
      debugPrint("[Flutter] >> Store Delete Failed Server Error!");
      state = previous; // 실패 시 롤백
      return null;
    }
    return result;
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
    if (result.code != 200) {
      debugPrint("[Flutter] >> Store Add Failed Server Error!");
      return null;
    }
    return result;
  }

  Future<ResponseModel?> updateStore({
    required int pId,
    required String ip,
    required int port,
    required String name,
    required int seatNumber,
    required double price,
    required double pricePercent,
    required String pcSpec,
    required String telecom,
    required String memo,
  }) async {
    final result = await managementUseCase.updateStore(
        pId: pId,
        ip: ip,
        port: port,
        name: name,
        seatNumber: seatNumber,
        price: price,
        pricePercent: pricePercent,
        pcSpec: pcSpec,
        telecom: telecom,
        memo: memo);
    if (result.code != 200) {
      debugPrint("[Flutter] >> Store Update Failed Server Error!");
      return null;
    }
    return result;
  }
}

final managementViewModelProvider = StateNotifierProvider<ManagementViewModel,
    AsyncValue<List<ManagementModel>>>((ref) {
  return ManagementViewModel(ref.read(managementUseCaseProvider));
});
