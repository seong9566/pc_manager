import 'package:ip_manager/model/management_model.dart';
import 'package:ip_manager/model/response_model.dart';
import '../../../model/ping_model.dart';

abstract class IManagementRepository {
  Future<List<ManagementModel>> getStoreList(String? pcName);

  Future<List<ManagementModel>> searchStoreByName(String name);

  Future<ResponseModel<void>> addStore({
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

  Future<ResponseModel<void>> updateStore({
    required int pId,
    required String ip,
    required int port,
    required String name,
    required int seatNumber,
    required double price,
    required double pricePercent,
    required String pcSpec,
    required String telecom,
    required String memo,
  });

  Future<ResponseModel<void>> deleteStore({required int pId});

  Future<ResponseModel<PingModel>> sendIpPing({required int pId});

  Future<List<ManagementModel>> getCountryStoreList({required int countryId});
}
