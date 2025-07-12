/// 전체 기간 조회
class PcRoomAnalytics {
  final int pcRoomId;
  final String pcRoomName;
  final String countryName;
  final String cityName;
  final String townName;
  final List<TimeUsage> analyList;

  PcRoomAnalytics({
    required this.pcRoomId,
    required this.pcRoomName,
    required this.countryName,
    required this.cityName,
    required this.townName,
    required this.analyList,
  });

  factory PcRoomAnalytics.fromJson(Map<String, dynamic> json) {
    return PcRoomAnalytics(
      pcRoomId: json['pcRoomId'],
      pcRoomName: json['pcRoomName'],
      countryName: json['countryName'],
      cityName: json['cityName'],
      townName: json['townName'],
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
  final String countryName;
  final String cityName;
  final String townName;
  final String usedPc;
  final String averageRate;
  final String pcPrice;
  final String foodPrice;
  final String totalPrice;
  final String pricePercent;

  PcStatModel({
    required this.pcName,
    required this.countryName,
    required this.cityName,
    required this.townName,
    required this.usedPc,
    required this.averageRate,
    required this.pcPrice,
    required this.foodPrice,
    required this.totalPrice,
    required this.pricePercent,
  });

  /// "6.25/100" 같은 usedPc에서 소수 버리고 정수만 리턴 ("6/100")
  String get usedPcFormatted {
    final parts = usedPc.split('/');
    final used = double.tryParse(parts[0])?.toInt() ?? 0;
    return '$used/${parts[1]}';
  }

  /// pcPrice 문자열에서 숫자만 파싱해 정수 반환
  int get pcPriceValue =>
      double.tryParse(pcPrice.replaceAll(RegExp(r'[^0-9\.-]'), ''))?.toInt() ??
      0;

  /// pcPriceValue에 천 단위 구분자와 "원" 단위 붙인 문자열
  String get pcPriceFormatted => '${_formatNumber(pcPriceValue)}원';
  
  /// 숫자에 천 단위 구분자(,) 추가
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  /// foodPrice에서 숫자 파싱 후 정수 반환
  int get foodPriceValue =>
      double.tryParse(foodPrice.replaceAll(RegExp(r'[^0-9\.-]'), ''))
          ?.toInt() ??
      0;

  /// foodPriceFormatted: 천 단위 구분자와 "원" 단위 붙이기
  String get foodPriceFormatted => '${_formatNumber(foodPriceValue)}원';

  /// totalPrice에서 숫자 파싱 후 정수 반환
  int get totalPriceValue =>
      double.tryParse(totalPrice.replaceAll(RegExp(r'[^0-9\.-]'), ''))
          ?.toInt() ??
      0;

  /// totalPriceFormatted: 천 단위 구분자와 "원" 단위 붙이기
  String get totalPriceFormatted => '${_formatNumber(totalPriceValue)}원';

  /// pricePercent에서 숫자 파싱 후 정수 반환
  int get pricePercentValue =>
      double.tryParse(pricePercent.replaceAll(RegExp(r'[^0-9\.-]'), ''))
          ?.toInt() ??
      0;

  /// pricePercentFormatted: "%" 단위 붙이기
  String get pricePercentFormatted => '$pricePercentValue%';

  factory PcStatModel.fromJson(Map<String, dynamic> json) {
    return PcStatModel(
      pcName: json['pcName'],
      countryName: json['countryName'],
      cityName: json['cityName'],
      townName: json['townName'],
      usedPc: json['usedPc'],
      averageRate: json['averageRate'],
      pcPrice: json['pcPrice'],
      foodPrice: json['foodPrice'],
      totalPrice: json['totalPrice'],
      pricePercent: json['pricePercent'],
    );
  }
}
