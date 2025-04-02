class UserRoleModel {
  final int pId;
  final String uId;
  final String role;

  UserRoleModel({required this.pId, required this.uId, required this.role});

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      pId: json['pId'],
      uId: json['uId'],
      role: json['role'],
    );
  }
}
