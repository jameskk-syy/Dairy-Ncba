import '../../../feature/auth/domain/models/validateotp.dart';

class ApiResponseDto extends ApiResponse {
  const ApiResponseDto({
    super.message = '',
    super.statusCode = 0,
    super.entity = const LoginResponse(),
  });

  factory ApiResponseDto.fromJson(Map<String, dynamic> json) {
    return ApiResponseDto(
      message: json['message'] as String? ?? '',
      statusCode: json['statusCode'] as int? ?? 0,
      entity: json['entity'] != null
          ? LoginResponseDto.fromJson(json['entity'] as Map<String, dynamic>)
          : const LoginResponse(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'entity': (entity is LoginResponseDto)
          ? (entity as LoginResponseDto).toJson()
          : entity.toJson(),
    };
  }
}

class LoginResponseDto extends LoginResponse {
  const LoginResponseDto({
    super.id = 0,
    super.username = '',
    super.mobile = '',
    super.roles = const [],
    super.token = '',
    super.tenantId = '',
    super.tenantName = '',
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((i) => RolesDto.fromJson(i as Map<String, dynamic>))
              .toList()
              .cast<Role>() ??
          [],
      token: json['token'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      tenantName: json['tenantName'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'mobile': mobile,
      'roles': roles.map((e) {
        if (e is RolesDto) {
          return e.toJson();
        } else {
          return RolesDto(name: e.name, accessRights: e.accessRights).toJson();
        }
      }).toList(),
      'token': token,
      'tenantId': tenantId,
      'tenantName': tenantName,
    };
  }
}

class RolesDto extends Role {
  const RolesDto({super.name = '', super.accessRights = const []});

  factory RolesDto.fromJson(Map<String, dynamic> json) {
    return RolesDto(
      name: json['name'] as String? ?? '',
      accessRights: (json['accessRights'] as List<dynamic>?)
              ?.map((i) => AccessRightsDto.fromJson(i as Map<String, dynamic>))
              .toList()
              .cast<AccessRight>() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessRights': accessRights.map((e) {
        if (e is AccessRightsDto) {
          return e.toJson();
        } else {
          return AccessRightsDto(name: e.name, accessRights: e.accessRights)
              .toJson();
        }
      }).toList(),
    };
  }
}

class AccessRightsDto extends AccessRight {
  const AccessRightsDto({super.name = '', super.accessRights = ''});

  factory AccessRightsDto.fromJson(Map<String, dynamic> json) {
    return AccessRightsDto(
      name: json['name'] as String? ?? '',
      accessRights: json['accessRights'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'accessRights': accessRights,
    };
  }
}
