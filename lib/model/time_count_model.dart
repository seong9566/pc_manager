/// 전체 기간 조회
class PcRoomAnalytics {
  final int pcRoomId;
  final String pcRoomName;
  final List<TimeUsage> analyList;

  PcRoomAnalytics({
    required this.pcRoomId,
    required this.pcRoomName,
    required this.analyList,
  });

  factory PcRoomAnalytics.fromJson(Map<String, dynamic> json) {
    return PcRoomAnalytics(
      pcRoomId: json['pcRoomId'],
      pcRoomName: json['pcRoomName'],
      analyList: List<TimeUsage>.from(
        json['analyList'].map((x) => TimeUsage.fromJson(x)),
      ),
    );
  }
}

/// 전체 기간 조회
class TimeUsage {
  final String time;
  final int count;

  TimeUsage({required this.time, required this.count});

  factory TimeUsage.fromJson(Map<String, dynamic> json) {
    return TimeUsage(
      time: json['time'],
      count: json['count'],
    );
  }
}

/// 기간별, 월별, 일별 데이터
class PcStatModel {
  final String pcName;
  final String usedPc;
  final String averageRate;
  final String pcPrice;
  final String foodPrice;
  final String totalPrice;
  final String pricePercent;

  PcStatModel({
    required this.pcName,
    required this.usedPc,
    required this.averageRate,
    required this.pcPrice,
    required this.foodPrice,
    required this.totalPrice,
    required this.pricePercent,
  });

  factory PcStatModel.fromJson(Map<String, dynamic> json) {
    return PcStatModel(
      pcName: json['pcName'],
      usedPc: json['usedPc'],
      averageRate: json['averageRate'],
      pcPrice: json['pcPrice'],
      foodPrice: json['foodPrice'],
      totalPrice: json['totalPrice'],
      pricePercent: json['pricePercent'],
    );
  }
}
