import 'package:ip_manager/model/management_model.dart';

abstract class IManagementRepository {
  Future<List<ManagementModel>> getStoreList(String? pcName);

  Future<List<ManagementModel>> searchStoreByName(String name);
}
