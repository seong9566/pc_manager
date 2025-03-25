import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/model/management_model.dart';

import '../data/management_repository_impl.dart';
import '../data/management_repository_interface.dart';

/// 의존 역전 원칙에 의해 UseCase는 Interface만 알고 있음
/// 실제로 어떤 구현체가 들어올지는 Provider로 의존성 주입으로 알게된다.
final managementUseCaseProvider = Provider<ManagementUseCase>((ref) {
  return ManagementUseCase(ref.read(managementRepositoryProvider));
});

class ManagementUseCase {
  /// Provider의 의존성 주입으로 인해 Interface를 생성해도 구현체가 동작하게 됌.
  final IManagementRepository managementRepository;

  ManagementUseCase(this.managementRepository);

  Future<List<ManagementModel>> getStoreList() async {
    return await managementRepository.getStoreList();
  }
}
