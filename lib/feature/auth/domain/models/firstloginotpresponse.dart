class OtpFirstLoginResponse {
  final String message;
  final int statusCode;
  final OtpFirstLoginEntity entity;

  OtpFirstLoginResponse({
    required this.message,
    required this.statusCode,
    required this.entity,
  });

  factory OtpFirstLoginResponse.fromJson(Map<String, dynamic> json) {
    return OtpFirstLoginResponse(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      entity: OtpFirstLoginEntity.fromJson(json['entity'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'entity': entity.toJson(),
    };
  }
}

class OtpFirstLoginEntity {
  final bool resetRequired;
  final String resetToken;
  final String username;

  OtpFirstLoginEntity({
    required this.resetRequired,
    required this.resetToken,
    required this.username,
  });

  factory OtpFirstLoginEntity.fromJson(Map<String, dynamic> json) {
    return OtpFirstLoginEntity(
      resetRequired: json['resetRequired'] ?? false,
      resetToken: json['resetToken'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resetRequired': resetRequired,
      'resetToken': resetToken,
      'username': username,
    };
  }
}
