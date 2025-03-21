import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseViewIndexProvider = StateProvider<int>((ref) => 2);

// DashBoardView() : 0
// ManagementView() : 1
// AnalyticsView() : 2
// StoreAddView() : 3
