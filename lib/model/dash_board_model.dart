class DashBoardModel {
  final String bestName;
  final DateTime analysisDate;
  final List<PcRoomItem> datas;

  DashBoardModel({
    required this.bestName,
    required this.analysisDate,
    required this.datas,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      bestName: json['bestName'],
      analysisDate: DateTime.parse(json['analysisDate']),
      datas:
          (json['datas'] as List).map((e) => PcRoomItem.fromJson(e)).toList(),
    );
  }
}

class PcRoomItem {
  final String pcRoomName;
  final int count;
  final int totalCount;
  final double rate;
  final String returnRate;

  PcRoomItem({
    required this.pcRoomName,
    required this.count,
    required this.totalCount,
    required this.rate,
    required this.returnRate,
  });

  factory PcRoomItem.fromJson(Map<String, dynamic> json) {
    return PcRoomItem(
      pcRoomName: json['pcRoomName'],
      count: json['count'],
      totalCount: json['totalCount'],
      rate: (json['rate'] as num).toDouble(),
      returnRate: json['returnRate'],
    );
  }
}
