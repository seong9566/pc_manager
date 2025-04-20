import '../../../model/account_model.dart';

abstract class IAccountRepository {
  /// 서버에서 계정 리스트를 가져옵니다.
  Future<List<AccountModel>> getAccounts();

  Future<bool> addAccount({
    required String userId,
    required String password,
    required bool adminYn,
    required String countryName,
  });

  Future<bool> updateAccount({
    required int pId,
    required String userId,
    required String password,
    required bool adminYn,
    required String countryName,
  });

  Future<bool> deleteAccount(int pId);
}
