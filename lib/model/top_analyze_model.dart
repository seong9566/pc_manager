class TopAnalyzeModel {
  final String topSalesTownName;
  final String topSalesStoreName;
  final String topUsedRateStoreName;

  TopAnalyzeModel({
    required this.topSalesTownName,
    required this.topSalesStoreName,
    required this.topUsedRateStoreName,
  });

  factory TopAnalyzeModel.fromJson(Map<String, dynamic> json) {
    return TopAnalyzeModel(
      topSalesTownName: json['topSalesTownName'] ?? '',
      topSalesStoreName: json['topSalesStoreName'] ?? '',
      topUsedRateStoreName: json['topUsedRateStoreName'] ?? '',
    );
  }
}
