class ResponseModel<T> {
  final String message;
  final T data;
  final int code;

  ResponseModel({
    required this.message,
    required this.data,
    required this.code,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ResponseModel(
      message: json['message'] ?? '',
      data: fromJsonT(json['data']),
      code: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'message': message,
      'data': toJsonT(data),
      'code': code,
    };
  }
}
