class ResponseModel {
  final String message;
  final dynamic data;
  final int code;

  ResponseModel({
    required this.message,
    required this.data,
    required this.code,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json['message'] ?? '',
      data: json['data'],
      code: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'code': code,
    };
  }
}
