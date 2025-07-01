class RegionInfoModel {
  final List<CountryModel> countries;

  RegionInfoModel({
    this.countries = const [],
  });

  factory RegionInfoModel.fromJson(List<dynamic> json) {
    return RegionInfoModel(
      countries: json.map((e) => CountryModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() => 
      countries.map((e) => e.toJson()).toList();
}

class CountryModel {
  final int countryId;
  final String countryName;
  final List<CityModel> cityDatas;

  CountryModel({
    required this.countryId,
    required this.countryName,
    this.cityDatas = const [],
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      countryId: json['countryId'] as int,
      countryName: json['countryName'] as String,
      cityDatas: (json['cityDatas'] as List<dynamic>?)
          ?.map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'countryId': countryId,
    'countryName': countryName,
    'cityDatas': cityDatas.map((e) => e.toJson()).toList(),
  };
}

class CityModel {
  final int cityId;
  final String cityName;
  final List<TownModel> townDatas;

  CityModel({
    required this.cityId,
    required this.cityName,
    this.townDatas = const [],
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityId: json['cityId'] as int,
      cityName: json['cityName'] as String,
      townDatas: (json['townDatas'] as List<dynamic>?)
          ?.map((e) => TownModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'cityId': cityId,
    'cityName': cityName,
    'townDatas': townDatas.map((e) => e.toJson()).toList(),
  };
}

class TownModel {
  final int townId;
  final String townName;

  TownModel({
    required this.townId,
    required this.townName,
  });

  factory TownModel.fromJson(Map<String, dynamic> json) {
    return TownModel(
      townId: json['townId'] as int,
      townName: json['townName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'townId': townId,
    'townName': townName,
  };
}
