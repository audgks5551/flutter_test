class ErrorResponse {
  final String code;
  final String message;

  ErrorResponse({
    required this.code,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> jsonMap) {
    return ErrorResponse(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
  }
}