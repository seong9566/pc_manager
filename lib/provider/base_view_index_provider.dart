import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/account/presentation/account_viewmodel.dart';
import '../features/dash_board/presentation/dash_board_viewmodel.dart';
import '../model/management_model.dart';

/// 선택된 매장 상태
final selectedStoreProvider = StateProvider<ManagementModel?>((_) => null);

/// 탭 인덱스 + 사이드 이펙트 관리 노티파이어
final tabIndexProvider = StateNotifierProvider<TabIndexNotifier, int>((ref) {
  return TabIndexNotifier(ref);
});

class TabIndexNotifier extends StateNotifier<int> {
  final Ref ref;

  TabIndexNotifier(this.ref) : super(0);

  /// 탭 전환 메소드
  void select(int newIndex) {
    if (newIndex == state) return;
    state = newIndex;
    _onTabChanged(newIndex);
  }

  /// 탭별로 실행할 로직을 여기서 분기
  void _onTabChanged(int index) {
    // 1) 선택된 매장 초기화
    if (index != 3) {
      ref.read(selectedStoreProvider.notifier).state = ManagementModel.empty();
    }

    // 2) 탭별 추가 로직
    switch (index) {
      case 0: // DashBoard
        // // 예: 대시보드 데이터 새로고침
        //   ref.read(dashBoardViewModelProvider.notifier).getDashBoardData();
        break;
      case 1: // Management
        // ref.read(managementViewModelProvider.notifier).getStoreList();
        break;
      case 2: // Analytics

        break;
      case 3: // StoreAdd
        // 아무 작업도 없을 수도 있고…
        break;
      case 4: // UserManagement
        ref.read(accountViewModel.notifier).init();
        break;
    }
  }
}
