import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/core/network/api_endpoints.dart';

import '../../../core/network/api_client.dart';
import '../../../model/account_model.dart';
import '../../../model/response_model.dart';

final accountServiceProvider = Provider<AccountService>((ref) {
  return AccountService(ref.read(apiClientProvider));
});

class AccountService {
  AccountService(this._apiClient);

  final ApiClient _apiClient;

  Future<ResponseModel<List<AccountModel>>> fetchAccounts() async {
    final resp = await _apiClient.request(
      DioMethod.get,
      url: ApiEndPoints.accountList,
    );

    final dynamic raw = resp.data;
    final Map<String, dynamic> json = raw as Map<String, dynamic>;

    debugPrint("[Flutter] >> raw : $raw");
    return ResponseModel.fromJson(
      json,
      (dataJson) => (dataJson as List<dynamic>)
          .map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<bool> addAccount({
    required String userId,
    required String password,
    required bool adminYn,
    required String countryName,
  }) async {
    final body = {
      "userId": userId,
      "password": password,
      "adminYn": adminYn,
      "countryName": countryName,
    };
    final resp = await _apiClient.request(
      DioMethod.post,
      data: body,
      url: ApiEndPoints.masterAddUser,
    );

    // resp.data가 String일 수도 있으니 파싱
    final raw = resp.data is String
        ? jsonDecode(resp.data as String)
        : resp.data as Map<String, dynamic>;

    // ResponseModel<bool> 으로 디코딩하고 data 필드(Boolean) 반환
    final model = ResponseModel<bool>.fromJson(
      raw,
      (d) => d as bool,
    );
    return model.data;
  }

  Future<bool> updateAccount({
    required int pId,
    required String userId,
    required String password,
    required bool adminYn,
    required bool useYn,
    required String countryName,
  }) async {
    final body = {
      'pId': pId,
      'uId': userId,
      'pwd': password,
      'adminYn': adminYn,
      'useYn': useYn,
      'countryName': countryName,
    };
    final resp = await _apiClient.request(DioMethod.post,
        url: ApiEndPoints.accountManagement, data: body);
    final raw = resp.data is String
        ? jsonDecode(resp.data as String)
        : resp.data as Map<String, dynamic>;

    final model = ResponseModel<bool>.fromJson(
      raw,
      (d) => d as bool,
    );
    if (model.code != 200) {
      throw Exception(model.message);
    }
    return model.data;
  }

  /// 계정 삭제
  Future<bool> deleteAccount(int pId) async {
    final body = {"pId": pId};
    final resp = await _apiClient.request(DioMethod.put,
        url: ApiEndPoints.accountDelete, data: body);
    final raw = resp.data is String
        ? jsonDecode(resp.data as String)
        : resp.data as Map<String, dynamic>;

    final model = ResponseModel<bool>.fromJson(
      raw,
      (d) => d as bool,
    );
    if (model.code != 200) {
      throw Exception(model.message);
    }
    return model.data;
  }
}
