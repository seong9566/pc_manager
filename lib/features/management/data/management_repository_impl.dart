import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/data/management_repository_interface.dart';
import 'package:ip_manager/model/management_model.dart';

import 'management_service.dart';

/// Repository 의 구현체를 주입
final managementRepositoryProvider = Provider<IManagementRepository>((ref) {
  return ManagementRepositoryImpl(ref.read(managementServiceProvider));
});

class ManagementRepositoryImpl implements IManagementRepository {
  final ManagementService managementService;

  ManagementRepositoryImpl(this.managementService);

  @override
  Future<List<ManagementModel>> getStoreList() async {
    final response = await managementService.getStoreList();

    /// rawList -> data 순서로 데이터 타입 일치 시켜주지 않을 시 JSArray<dynamic> 에러 발생
    final List<dynamic> rawList = response.data['data'];
    final List<ManagementModel> data =
        rawList.map((item) => ManagementModel.fromJson(item)).toList();
    return data;
  }
}
