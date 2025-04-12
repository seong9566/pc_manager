class ManagementModel {
  /**
   *
   * int pId { get; set; }
      string ip { get; set; }
      int port { get; set; }
      string name { get; set; }
      string addr { get; set; }
      int seatNumber { get; set; }
      float price { get; set; }
      float pricePercent { get; set; }
      string pcSpec { get; set; }
      string telecom { get; set; }
      string memo { get; set; }
      string region { get; set; }
      int countryTbId { get; set; }
      int cityTbId { get; set; }
      int townTbId { get; set; }
   */
  final int? pId;
  final String? ip;
  final int? port;
  final String? name;
  final String? addr;
  final int? seatNumber;
  final int? price;
  final double? pricePercent;
  final String? pcSpec;
  final String? telecom;
  final String? memo;
  final String? region;
  final int? countryTbId;
  final int? cityTbId;
  final int? townTbId;

  ManagementModel({
    required this.pId,
    required this.ip,
    required this.port,
    required this.name,
    required this.addr,
    required this.seatNumber,
    required this.price,
    required this.pricePercent,
    required this.pcSpec,
    required this.telecom,
    required this.memo,
    required this.region,
    required this.countryTbId,
    required this.cityTbId,
    required this.townTbId,
  });

  factory ManagementModel.fromJson(Map<String, dynamic> json) {
    return ManagementModel(
      pId: json['pId'] ?? 0,
      ip: json['ip'] ?? '',
      port: json['port'] ?? 0,
      name: json['name'] ?? '',
      addr: json['addr'] ?? '',
      seatNumber: json['seatNumber'] ?? 0,
      price: json['price'] ?? 0,
      pricePercent: json['pricePercent'] ?? '',
      pcSpec: json['pcSpec'] ?? '',
      telecom: json['telecom'] ?? '',
      memo: json['memo'] ?? '',
      region: json['region'] ?? '',
      countryTbId: json['countryTbId'] ?? 0,
      cityTbId: json['cityTbId'] ?? 0,
      townTbId: json['townTbId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pId': pId,
      'ip': ip,
      'port': port,
      'name': name,
      'addr': addr,
      'seatNumber': seatNumber,
      'price': price,
      'pricePercent': pricePercent,
      'pcSpec': pcSpec,
      'telecom': telecom,
      'memo': memo,
      'region': region,
      'countryTbId': countryTbId,
      'cityTbId': cityTbId,
      'townTbId': townTbId,
    };
  }

  factory ManagementModel.empty() {
    return ManagementModel(
      pId: 0,
      ip: null,
      port: null,
      name: '',
      addr: '',
      seatNumber: null,
      price: null,
      pricePercent: null,
      pcSpec: '',
      telecom: '',
      memo: '',
      region: '',
      countryTbId: 0,
      cityTbId: 0,
      townTbId: 0,
    );
  }

  /// pId는 서버에서 데이터를 만들 때 고유 값으로 부여 하기 때문에 0은 null값과 동일함.
  bool get isEmpty => pId == 0;
}
