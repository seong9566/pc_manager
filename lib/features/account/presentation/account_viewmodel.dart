// lib/presentation/user_management_viewmodel.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/account/domain/account_use_case.dart';

import '../../../model/account_model.dart';

/// 계정 리스트 상태
class AccountState {
  final List<AccountModel> accountModel;

  AccountState({required this.accountModel});

  AccountState copyWith({
    List<AccountModel>? accountModel,
  }) {
    return AccountState(
      accountModel: accountModel ?? this.accountModel,
    );
  }
}

class AccountViewModel extends StateNotifier<AccountState> {
  final AccountUseCase _useCase;

  AccountViewModel(this._useCase) : super(AccountState(accountModel: []));

  /// 초기화: 서버에서 계정 목록 받아 상태 업데이트
  Future<void> init() async {
    try {
      final accounts = await _useCase.execute();
      state = state.copyWith(accountModel: accounts);
    } catch (e, st) {
      debugPrint('AccountViewModel.init error: $e\n$st');
    }
  }

  /// 계정 추가 후 리스트 갱신
  Future<bool> addAccount({
    required String userId,
    required String password,
    required bool adminYn,
    required String countryName,
  }) async {
    try {
      final success = await _useCase.addAccount(
        userId: userId,
        password: password,
        adminYn: adminYn,
        countryName: countryName,
      );
      if (success) {
        refresh();
      }
      return success;
    } catch (e, st) {
      debugPrint('AccountViewModel.addAccount error: $e\n$st');
      return false;
    }
  }

  Future<bool> updateAccount({
    required int pId,
    required String userId,
    required String? password,
    required bool adminYn,
    required bool useYn,
    required String countryName,
  }) async {
    try {
      final success = await _useCase.updateAccount(
        pId: pId,
        userId: userId,
        password: password,
        adminYn: adminYn,
        useYn: useYn,
        countryName: countryName,
      );
      if (success) await refresh();
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteAccount(int pId) async {
    try {
      final success = await _useCase.deleteAccount(pId);
      if (success) await init();
      return success;
    } catch (_) {
      return false;
    }
  }

  /// 화면에서 호출할 리프레시
  Future<void> refresh() async {
    try {
      final accounts = await _useCase.execute();
      state = state.copyWith(accountModel: accounts);
    } catch (e, st) {
      debugPrint('AccountViewModel.refresh error: $e\n$st');
    }
  }
}

/// ViewModel Provider: AccountState 타입으로 노출
final accountViewModel = StateNotifierProvider<AccountViewModel, AccountState>(
  (ref) {
    final useCase = ref.read(accountUseCaseProvider);
    return AccountViewModel(useCase);
  },
);
