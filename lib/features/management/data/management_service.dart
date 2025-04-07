import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

final managementServiceProvider = Provider<ManagementService>((ref) {
  return ManagementService(ref.read(apiClientProvider));
});

class ManagementService {
  final ApiClient apiClient;

  ManagementService(this.apiClient);

  Future<Response> getStoreList(String? pcName) async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getStoreList,
      data: {'searchPcName': pcName},
    );
  }

  Future<Response> searchStoreByName(String name) async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getStoreSearchName,
      data: {"search": name},
    );
  }

  Future<Response> addStore({required Map<String, Object> data}) async {
    return await apiClient.request(
      DioMethod.post,
      url: ApiEndPoints.addStore,
      data: data,
    );
  }

  Future<Response> deleteStore({required Map<String, Object> data}) async {
    return await apiClient.request(
      DioMethod.put,
      url: ApiEndPoints.deleteStore,
      data: data,
    );
  }
}
