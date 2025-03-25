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

  Future<Response> getStoreList() async {
    return await apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.getStoreList,
      data: {"pagenumber": 1},
    );
  }
}
