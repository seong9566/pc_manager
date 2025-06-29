import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/account_model.dart';
import '../data/account_repository_impl.dart';
import '../data/account_repository_interface.dart';

// IUserRepository만 알고, 구현체는 DI로 주입
final accountUseCaseProvider = Provider<AccountUseCase>((ref) {
  return AccountUseCase(ref.read(accountRepositoryProvider));
});

class AccountUseCase {
  final IAccountRepository _repo;

  AccountUseCase(this._repo);

  /// 계정 리스트를 가져옵니다.
  Future<List<AccountModel>> execute() {
    return _repo.getAccounts();
  }

  Future<bool> addAccount({
    required String userId,
    required String password,
    required bool adminYn,
    required String countryName,
  }) {
    return _repo.addAccount(
      userId: userId,
      password: password,
      adminYn: adminYn,
      countryName: countryName,
    );
  }

  /// 계정 수정
  Future<bool> updateAccount({
    required int pId,
    required String userId,
    required String? password,
    required bool adminYn,
    required bool useYn,
    required String countryName,
  }) {
    return _repo.updateAccount(
      pId: pId,
      userId: userId,
      password: password,
      adminYn: adminYn,
      useYn: useYn,
      countryName: countryName,
    );
  }

  /// 계정 삭제
  Future<bool> deleteAccount(int pId) {
    return _repo.deleteAccount(pId);
  }
}
