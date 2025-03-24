/**
 * API 로 전달 받은 데이터 원본
 */
class LoginModel {
  Data? data;
  String? message;
  int? code;

  LoginModel({this.data, this.message, this.code});

  LoginModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    code = json['code'];
  }
}

class SignModel {
  final String? message;
  final bool? success;
  final int? code;

  SignModel({this.message, this.success, this.code});

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      message: json['message'],
      success: json['data'], // true/false
      code: json['code'],
    );
  }
}

class Data {
  String? accessToken;

  Data({this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    return data;
  }
}
