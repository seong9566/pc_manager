import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/data/management_repository_interface.dart';
import 'package:ip_manager/model/management_model.dart';

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

    /// rawList -> data 순서로 데이터 타입 일치 시켜주지 않을 시 JSArray<dynamic> 에러 발생
    final List<dynamic> rawList = response.data['data'];
    final List<ManagementModel> data =
        rawList.map((item) => ManagementModel.fromJson(item)).toList();
    return data;
  }

  @override
  Future<List<ManagementModel>> searchStoreByName(String name) async {
    final response = await managementService.searchStoreByName(name);

    final List<dynamic> rawList = response.data['data'];
    final List<ManagementModel> data =
        rawList.map((item) => ManagementModel.fromJson(item)).toList();
    return data;
  }

  @override
  Future<ResponseModel> deleteStore({required int pId}) async {
    final data = {"pId": pId};
    final response = await managementService.deleteStore(data: data);
    debugPrint("[Flutter] >> response : $response");
    final result = ResponseModel.fromJson(response.data);
    return result;
  }

  @override
  Future<ResponseModel> addStore(
      {required String ip,
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
      String? memo}) async {
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
    final result = ResponseModel.fromJson(response.data);
    return result;
  }
}
