import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/model/management_model.dart';

import '../../../model/response_model.dart';
import '../data/management_repository_impl.dart';
import '../data/management_repository_interface.dart';

/**
 * UseCase의 역할 : 비즈니스 규칙(예: 필터링, 조건 판단 등)을 담당
 */

/// 의존 역전 원칙에 의해 UseCase는 Interface만 알고 있음
/// 실제로 어떤 구현체가 들어올지는 Provider로 의존성 주입으로 알게된다.
final managementUseCaseProvider = Provider<ManagementUseCase>((ref) {
  return ManagementUseCase(ref.read(managementRepositoryProvider));
});

class ManagementUseCase {
  /// Provider의 의존성 주입으로 인해 Interface를 생성해도 구현체가 동작하게 됌.
  final IManagementRepository managementRepository;

  ManagementUseCase(this.managementRepository);

  Future<List<ManagementModel>> getStoreList(String? pcName) async {
    return await managementRepository.getStoreList(pcName);
  }

  Future<List<ManagementModel>> searchStoreByName(String name) async {
    return await managementRepository.searchStoreByName(name);
  }

  Future<ResponseModel?> deleteStore({required int pId}) async {
    return await managementRepository.deleteStore(pId: pId);
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
    try {
      final result = await managementRepository.addStore(
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
      return result;
    } catch (e) {
      debugPrint("[Flutter] >> Add Store Error : $e");
      return null;
    }
  }
}
