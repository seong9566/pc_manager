class PingModel {
  final int used;
  final int unUsed;

  PingModel({
    required this.used,
    required this.unUsed,
  });

  factory PingModel.fromJson(Map<String, dynamic> json) {
    return PingModel(
      used: json['used'] as int? ?? 0,
      unUsed: json['unUsed'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'used': used,
      'unUsed': unUsed,
    };
  }

  static PingModel get empty => PingModel(used: 0, unUsed: 0);

  int get total => used + unUsed;
}
