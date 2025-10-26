class PasswordChangeResponse {
  final String? message;
  final int? statusCode;

  PasswordChangeResponse({
    this.message,
    this.statusCode,
  });

  factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) {
    return PasswordChangeResponse(
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
    };
  }
}
