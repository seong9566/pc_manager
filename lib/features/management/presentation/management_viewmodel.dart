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

  Future<void> getCountryStoreList({int? countryId, String? cityName}) async {
    state = const AsyncLoading();
    try {
      List<ManagementModel> allStores;

      if (countryId != null) {
        // 기존 방식: countryId로 검색
        allStores =
            await managementUseCase.getCountryStoreList(countryId: countryId);
      } else if (cityName != null) {
        // 새로운 방식: 도시 이름으로 검색
        // 도시 이름으로 countryId를 찾아서 검색해야 함
        // 임시로 빈 리스트 반환 (실제로는 도시 이름으로 countryId를 찾는 로직 구현 필요)
        allStores = await managementUseCase.getStoreList(null);
        // 도시 이름으로 필터링
        allStores =
            allStores.where((store) => store.countryName == cityName).toList();
      } else {
        // 둘 다 null이면 전체 목록 반환
        allStores = await managementUseCase.getStoreList(null);
      }

      state = AsyncValue.data(allStores);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 지역 필터링: 국가(지역), 도시, 동네 선택에 따른 필터링
  /// 각 매개변수는 옵셔널이며, 제공된 값에 따라 필터링을 수행합니다.
  /// 예: countryName만 제공 → 해당 국가의 모든 PC방
  /// countryName + cityName 제공 → 해당 국가의 해당 도시에 있는 모든 PC방
  /// countryName + cityName + townName 제공 → 해당 국가의 해당 도시의 해당 동네에 있는 모든 PC방
  /// 지역 필터링: 국가(지역), 도시, 동네 선택에 따른 필터링
  /// 이미 캐싱된 데이터를 사용하여 API 호출 없이 필터링합니다.
  void filterStoresByLocation({
    String? countryName,
    String? cityName,
    String? townName,
  }) {
    state = const AsyncLoading();
    try {
      final filteredStores = originAllStores.where((store) {
        // countryName만 들어온 경우
        if (countryName != null && cityName == null && townName == null) {
          return store.addr?.contains(countryName) ?? false;
        }

        // countryName, cityName만 들어온 경우
        if (countryName != null && cityName != null && townName == null) {
          return (store.addr?.contains(countryName) ?? false) &&
              (store.addr?.contains(cityName) ?? false);
        }

        // countryName, cityName, townName 모두 들어온 경우
        if (countryName != null && cityName != null && townName != null) {
          return (store.addr?.contains(countryName) ?? false) &&
              (store.addr?.contains(cityName) ?? false) &&
              (store.addr?.contains(townName) ?? false);
        }

        // 아무 조건도 없을 때는 전체 반환
        return true;
      }).toList();

      state = AsyncValue.data(filteredStores);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// 필터링 초기화 기능
  /// 원본 데이터(originAllStores)를 현재 상태로 설정하여 모든 필터를 초기화합니다.
  /// 필터링에 사용되는 외부 상태는 반드시 호출자가 초기화해야 합니다.
  void resetFilters() {
    // 경고창 없이 직접 상태를 업데이트하기 위해 임시로 loading 상태로 설정
    state = const AsyncLoading();
    // 원본 데이터로 상태 재설정
    state = AsyncValue.data(List<ManagementModel>.from(originAllStores));
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
