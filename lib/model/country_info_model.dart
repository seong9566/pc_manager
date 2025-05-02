class CountryInfoModel {
  final int pId;
  final String countryName;

  CountryInfoModel({
    required this.pId,
    required this.countryName,
  });

  /// JSON → CountryInfoModel
  factory CountryInfoModel.fromJson(Map<String, dynamic> json) {
    return CountryInfoModel(
      pId: json['pId'] is int
          ? json['pId'] as int
          : int.tryParse(json['pId'].toString()) ?? 0,
      countryName: json['countryName']?.toString() ?? '',
    );
  }

  /// CountryInfoModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'pId': pId,
      'countryName': countryName,
    };
  }
}
