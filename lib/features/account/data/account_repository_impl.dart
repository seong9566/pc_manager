import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/account_model.dart';
import 'account_management_service.dart';
import 'account_repository_interface.dart';

// IUserRepository 구현체 주입
final accountRepositoryProvider = Provider<IAccountRepository>((ref) {
  return AccountRepositoryImpl(ref.read(accountServiceProvider));
});

class AccountRepositoryImpl implements IAccountRepository {
  AccountRepositoryImpl(this._service);

  final AccountService _service;

  @override
  Future<List<AccountModel>> getAccounts() async {
    final respModel = await _service.fetchAccounts();
    if (respModel.code != 200) {
      throw Exception('Error ${respModel.code}: ${respModel.message}');
    }
    return respModel.data;
  }

  @override
  Future<bool> addAccount({
    required String userId,
    required String password,
    required bool adminYn,
    required String countryName,
  }) {
    // Service에서 bool 리턴받아 그대로 전달
    return _service.addAccount(
      userId: userId,
      password: password,
      adminYn: adminYn,
      countryName: countryName,
    );
  }

  @override
  Future<bool> updateAccount({
    required int pId,
    required String userId,
    required String? password,
    required bool adminYn,
    required bool useYn,
    required String countryName,
  }) async {
    // 지역 변수를 사용하여 값 처리
    String? finalPassword = password == '' ? null : password;
    final ok = await _service.updateAccount(
      pId: pId,
      userId: userId,
      password: finalPassword,
      adminYn: adminYn,
      useYn: useYn,
      countryName: countryName,
    );
    return ok;
  }

  @override
  Future<bool> deleteAccount(int pId) async {
    final ok = await _service.deleteAccount(pId);
    return ok;
  }
}
