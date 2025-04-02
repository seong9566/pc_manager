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
  final int pId;
  final String ip;
  final int port;
  final String name;
  final String addr;

  /// flutter dart에서 float 타입이 없이 전부다 double라서 아마 이거 써도 될거에요 ㅇㅇ 더블로 ㄱㄱ
  final int seatNumber;
  final int price;
  final double pricePercent;
  final String pcSpec;
  final String telecom;
  final String memo;
  final String region;
  final int countryTbId;
  final int cityTbId;
  final int townTbId;

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
}
