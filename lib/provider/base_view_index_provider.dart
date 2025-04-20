import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/management_model.dart';

final baseViewIndexProvider = StateProvider<int>((ref) => 0);

/// 선택된 매장을 전역에서 관리할 수 있는 Provider
/// AddView가 IndexedStack으로 관리 되고 있어서, 페이지 이동 시 파라미터 전달이 불가능
/// 중간 매개체로 Provider를 선언해서 사용해서 item을 전달
final selectedStoreProvider = StateProvider<ManagementModel?>((ref) => null);

// DashBoardView() : 0
// ManagementView() : 1
// AnalyticsView() : 2
// StoreAddView() : 3
// UserManagementView() : 4
