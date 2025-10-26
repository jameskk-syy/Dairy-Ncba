import 'package:equatable/equatable.dart';

class ApiResponse extends Equatable {
  final String message;
  final int statusCode;
  final LoginResponse entity;

  const ApiResponse({
    this.message = '',
    this.statusCode = 0,
    this.entity = const LoginResponse(),
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] as String? ?? '',
      statusCode: json['statusCode'] as int? ?? 0,
      entity: json['entity'] != null
          ? LoginResponse.fromJson(json['entity'] as Map<String, dynamic>)
          : const LoginResponse(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'entity': entity.toJson(),
    };
  }

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class LoginResponse extends Equatable {
  final int id;
  final String username;
  final String mobile;
  final List<Role> roles;
  final String token;
  final String tenantId;
  final  String tenantName;

  const LoginResponse({
    this.id = 0,
    this.username = '',
    this.mobile = '',
    this.roles = const [],
    this.token = '',
    this.tenantId = '',
    this.tenantName = '',
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      token: json['token'] as String? ?? '',
      tenantName: json['tenantName'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'mobile': mobile,
      'token': token,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'roles': roles.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, username, mobile, roles, token, tenantId,tenantName];
}

class Role extends Equatable {
  final String name;
  final List<AccessRight> accessRights;

  const Role({this.name = '', this.accessRights = const []});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'] as String? ?? '',
      accessRights: (json['accessRights'] as List<dynamic>?)
              ?.map((e) => AccessRight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessRights': accessRights.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [name, accessRights];
}

class AccessRight extends Equatable {
  final String name;
  final String accessRights;

  const AccessRight({this.name = '', this.accessRights = ''});

  factory AccessRight.fromJson(Map<String, dynamic> json) {
    return AccessRight(
      name: json['name'] as String? ?? '',
      accessRights: json['accessRights'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'accessRights': accessRights};
  }

  @override
  List<Object?> get props => [name, accessRights];
}
