class DashBoardModel {
  final String message;
  final DashBoardData data;
  final int code;

  DashBoardModel({
    required this.message,
    required this.data,
    required this.code,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      message: json['message'] ?? '',
      data: DashBoardData.fromJson(json['data'] ?? {}),
      code: json['code'] ?? 0,
    );
  }
}

class DashBoardData {
  final String bestName;
  final DateTime analysisDate;
  final List<DashBoardStoreData> datas;

  DashBoardData({
    required this.bestName,
    required this.analysisDate,
    required this.datas,
  });

  factory DashBoardData.fromJson(Map<String, dynamic> json) {
    return DashBoardData(
      bestName: json['bestName'] ?? '',
      analysisDate: DateTime.parse(json['analysisDate']),
      datas:
          (json['datas'] as List<dynamic>)
              .map((e) => DashBoardStoreData.fromJson(e))
              .toList(),
    );
  }
}

class DashBoardStoreData {
  final String pcRoomName;
  final int count;
  final int totalCount;
  final double rate;
  final String returnRate;

  DashBoardStoreData({
    required this.pcRoomName,
    required this.count,
    required this.totalCount,
    required this.rate,
    required this.returnRate,
  });

  factory DashBoardStoreData.fromJson(Map<String, dynamic> json) {
    return DashBoardStoreData(
      pcRoomName: json['pcRoomName'] ?? '',
      count: json['count'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
      returnRate: json['returnRate'] ?? '',
    );
  }
}
