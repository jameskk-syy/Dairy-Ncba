class AuthLoginResponse {
  final String? message;
  final int? statusCode;
  final Entity? entity;

  AuthLoginResponse({
    this.message,
    this.statusCode,
    this.entity,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    return AuthLoginResponse(
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
      entity: json['entity'] != null ? Entity.fromJson(json['entity']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'entity': entity?.toJson(),
    };
  }
}

class Entity {
  final String? email;
  final String? phone;
  final String? otp;
  final String? username;
  final  String? firstLogin;

  Entity({
    this.email,
    this.username,
    this.phone,
    this.otp,
    this.firstLogin,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      email: json['email'] as String?,
      username: json['username'] as String?,
      firstLogin: json['FirstLogin'] as String ?,
      phone:  json['phone'] as String ?,
      otp:  json['otp'] as String ?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'firstLogin': firstLogin,
      'phone': phone,
      'otp' :otp
    };
  }
}
