class AccountModel {
  final int pId;

  /// Role
  final String uId;
  final bool adminYn;
  final bool useYn;
  final String createDt;

  AccountModel({
    required this.pId,
    required this.uId,
    required this.adminYn,
    required this.useYn,
    required this.createDt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      pId: json['pId'] as int,
      uId: json['uId'] as String,
      adminYn: json['adminYn'] as bool,
      useYn: json['useYn'] as bool,
      createDt: json['createDt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'pId': pId,
        'uId': uId,
        'adminYn': adminYn,
        'useYn': useYn,
        'createDt': createDt,
      };
}
