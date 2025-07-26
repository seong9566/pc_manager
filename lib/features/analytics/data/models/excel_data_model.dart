class ExcelDataResponse {
  final String message;
  final List<ExcelPcRoomData> data;
  final int code;

  ExcelDataResponse({
    required this.message,
    required this.data,
    required this.code,
  });

  factory ExcelDataResponse.fromJson(Map<String, dynamic> json) {
    return ExcelDataResponse(
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => ExcelPcRoomData.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as int,
    );
  }
}

class ExcelPcRoomData {
  final int pcId;
  final String pcName;
  final List<PcRoomDailyData> datas;

  ExcelPcRoomData({
    required this.pcId,
    required this.pcName,
    required this.datas,
  });

  factory ExcelPcRoomData.fromJson(Map<String, dynamic> json) {
    return ExcelPcRoomData(
      pcId: json['pcId'] as int,
      pcName: json['pcName'] as String,
      datas: (json['datas'] as List)
          .map((e) => PcRoomDailyData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PcRoomDailyData {
  final String analyzeDT;
  final int countryId;
  final String countryName;
  final int cityId;
  final String cityName;
  final int townId;
  final String townName;
  final double usedPc;
  final double averageRate;
  final double pcPrice;
  final double foodPrice;
  final double totalPrice;
  final int seatNumber;
  final String pricePercent;

  PcRoomDailyData({
    required this.analyzeDT,
    required this.countryId,
    required this.countryName,
    required this.cityId,
    required this.cityName,
    required this.townId,
    required this.townName,
    required this.usedPc,
    required this.averageRate,
    required this.pcPrice,
    required this.foodPrice,
    required this.totalPrice,
    required this.seatNumber,
    required this.pricePercent,
  });

  factory PcRoomDailyData.fromJson(Map<String, dynamic> json) {
    return PcRoomDailyData(
      analyzeDT: json['analyzeDT'] as String,
      countryId: (json['countryId'] as num).toInt(),
      countryName: json['countryName'] as String,
      cityId: (json['cityId'] as num).toInt(),
      cityName: json['cityName'] as String,
      townId: (json['townId'] as num).toInt(),
      townName: json['townName'] as String,
      usedPc: (json['usedPc'] as num).toDouble(),
      averageRate: (json['averageRate'] as num).toDouble(),
      pcPrice: (json['pcPrice'] as num).toDouble(),
      foodPrice: (json['foodPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      seatNumber: (json['seatNumber'] as num).toInt(),
      pricePercent: json['pricePercent'] as String,
    );
  }
}
