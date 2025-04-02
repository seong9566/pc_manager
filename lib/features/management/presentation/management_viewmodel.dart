import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_manager/features/management/domain/management_use_case.dart';
import 'package:ip_manager/model/management_model.dart';

/**
 * AsyncValue : 데이터 통신을 하고 비동기 데이터를 관리 하기 위함.
 * loading, success, error를 하나의 타입으로 관리가 가능 하기 때문.
 */
final managementViewModelProvider = StateNotifierProvider<ManagementViewModel,
    AsyncValue<List<ManagementModel>>>((ref) {
  return ManagementViewModel(ref.read(managementUseCaseProvider));
});

class ManagementViewModel
    extends StateNotifier<AsyncValue<List<ManagementModel>>> {
  final ManagementUseCase managementUseCase;

  ManagementViewModel(this.managementUseCase) : super(const AsyncLoading()) {
    getStoreList();
  }

  Future<void> getStoreList({String? pcName}) async {
    try {
      List<ManagementModel> result;
      // result = await managementUseCase.getStoreList(pcName);
      // state = AsyncValue.data(result);
      Future.delayed(Duration(milliseconds: 1000)).then((_) async {
        result = await managementUseCase.getStoreList(pcName);
        state = AsyncValue.data(result);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> getStoreSearchName(String name) async {
    state = const AsyncLoading();

    try {
      final result = await managementUseCase.searchStoreByName(name);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
