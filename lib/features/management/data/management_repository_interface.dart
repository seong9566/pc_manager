import 'package:ip_manager/model/management_model.dart';
import 'package:ip_manager/model/response_model.dart';

abstract class IManagementRepository {
  Future<List<ManagementModel>> getStoreList(String? pcName);

  Future<List<ManagementModel>> searchStoreByName(String name);

  Future<ResponseModel> addStore({
    required String ip,
    required int port,
    required String name,
    required String addr,
    required int seatNumber,
    required double price,
    required double pricePercent,
    required String countryName,
    required String cityName,
    required String townName,
    String? pcSpec,
    String? telecom,
    String? memo,
  });
}
