import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/data/management_repository_interface.dart';
import 'package:ip_manager/model/management_model.dart';

import '../../../model/ping_model.dart';
import '../../../model/response_model.dart';
import 'management_service.dart';

/**
 * Repository의 역할 :
 * UseCase와 Data Layer(Service) 사이를 연결
 * Entity → DTO or Map 변환 작업은 여기서 하는 게 일반적
 */

/// Repository 의 구현체를 주입
final managementRepositoryProvider = Provider<IManagementRepository>((ref) {
  return ManagementRepositoryImpl(ref.read(managementServiceProvider));
});

class ManagementRepositoryImpl implements IManagementRepository {
  final ManagementService managementService;

  ManagementRepositoryImpl(this.managementService);

  @override
  Future<List<ManagementModel>> getStoreList(String? pcName) async {
    final response = await managementService.getStoreList(pcName);
    final parsed = ResponseModel<List<dynamic>>.fromJson(
      response.data,
      (json) => json,
    );
    return parsed.data.map((e) => ManagementModel.fromJson(e)).toList();
  }

  @override
  Future<List<ManagementModel>> searchStoreByName(String name) async {
    final response = await managementService.searchStoreByName(name);
    final parsed = ResponseModel<List<dynamic>>.fromJson(
      response.data,
      (json) => json,
    );
    return parsed.data.map((e) => ManagementModel.fromJson(e)).toList();
  }

  @override
  Future<ResponseModel<void>> deleteStore({required int pId}) async {
    final data = {"pId": pId};
    final response = await managementService.deleteStore(data: data);
    return ResponseModel<void>.fromJson(response.data, (_) => null);
  }

  @override
  Future<ResponseModel<void>> addStore({
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
    final data = {
      "ip": ip,
      "port": port,
      "name": name,
      "addr": addr,
      "seatNumber": seatNumber,
      "price": price,
      "pricePercent": pricePercent,
      "countryName": countryName,
      "cityName": cityName,
      "townName": townName,
      if (pcSpec != null) "pcSpec": pcSpec,
      if (telecom != null) "telecom": telecom,
      if (memo != null) "memo": memo,
    };
    final response = await managementService.addStore(data: data);
    return ResponseModel<void>.fromJson(response.data, (_) {});
  }

  @override
  Future<ResponseModel<void>> updateStore({
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
    final data = {
      "pId": pId,
      "ip": ip,
      "port": port,
      "name": name,
      "seatNumber": seatNumber,
      "price": price,
      "pricePercent": pricePercent,
      "pcSpec": pcSpec,
      "telecom": telecom,
      "memo": memo,
    };
    final response = await managementService.updateStore(data: data);
    return ResponseModel<void>.fromJson(response.data, (_) {});
  }

  @override
  Future<ResponseModel<PingModel>> sendIpPing({required int pId}) async {
    final data = {"pId": pId};
    final response = await managementService.sendIpPing(data: data);

    if (response.data["data"] == null) {
      return ResponseModel<PingModel>(
        message: response.data["message"] ?? '',
        code: response.data["code"] ?? 0,
        data: PingModel.empty,
      );
    }

    return ResponseModel<PingModel>.fromJson(
      response.data,
      (json) => PingModel.fromJson(json),
    );
  }
}
