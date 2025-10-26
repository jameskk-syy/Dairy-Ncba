

import '../../domain/models/routes_model.dart';

class RoutesResponseDto extends RoutesResponseModel {


  RoutesResponseDto({super.message, super.statusCode, super.entity});

  factory RoutesResponseDto.fromJson(Map<String, dynamic> json) {
    return RoutesResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null ? (json['entity'] as List).map((i) => RoutesEntityDto.fromJson(i)).toList() : null,
    );
  }
}

class RoutesEntityDto extends RoutesEntityModel {


  RoutesEntityDto({super.id, super.route, super.collectors, super.routeCode});

 factory RoutesEntityDto.fromJson(Map<String, dynamic> json) {
    return RoutesEntityDto(
      id: json['id'],
      route: json['route'],
      routeCode: json['routeCode'],
      collectors: json['collectors'] != null ? (json['collectors'] as List).map((i) => CollectorsEntityDto.fromJson(i)).toList() : null,
    );
  }

}

class CollectorsEntityDto extends CollectorsEntityModel {
  CollectorsEntityDto({super.id, super.name});

  factory CollectorsEntityDto.fromJson(Map<String, dynamic> json) {
    return CollectorsEntityDto(
      id: json['id'],
      name: json['name'],
    );
  }
}
