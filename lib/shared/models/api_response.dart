class ApiResponse<T> {
  final int code;
  final String? message;
  final T? data;
  final String? error;
  final bool success;

  const ApiResponse({
    required this.code,
    this.message,
    this.data,
    this.error,
    required this.success,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] ?? 0,
      message: json['message']?.toString(),
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      error: json['error']?.toString(),
      success: (json['code'] ?? 0) >= 200 && (json['code'] ?? 0) < 300,
    );
  }

  factory ApiResponse.success({
    required T data,
    String? message,
    int code = 200,
  }) {
    return ApiResponse<T>(
      code: code,
      message: message,
      data: data,
      success: true,
    );
  }

  factory ApiResponse.error({
    required String error,
    String? message,
    int code = 400,
  }) {
    return ApiResponse<T>(
      code: code,
      message: message,
      error: error,
      success: false,
    );
  }

  bool get isSuccess => success && error == null;
  bool get isError => !success || error != null;

  @override
  String toString() {
    return 'ApiResponse(code: $code, success: $success, message: $message, error: $error)';
  }
}
