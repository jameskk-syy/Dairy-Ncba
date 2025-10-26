import '../../domain/models/collector_routes_model.dart';

class CollectorRoutesResponseDto extends CollectorRoutesModel {
  /*String? message;
  int? statusCode;
  List<CollectorRoutesEntityDto>? entity;*/

  CollectorRoutesResponseDto({super.message, super.statusCode, super.entity});

  factory CollectorRoutesResponseDto.fromJson(Map<String, dynamic> json) {
    return CollectorRoutesResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null
          ? (json['entity'] as List)
              .map((i) => CollectorRoutesEntityDto.fromJson(i))
              .toList()
          : null,
    );
  }

  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['statusCode'] = statusCode;
    if (entity != null) {
      data['entity'] = entity!.map((v) => v.toJson()).toList();
    }
    return data;
  }*/
}

class CollectorRoutesEntityDto extends CollectorRoutesEntityResponse {
  /*String? ward;
  String? route;
  String? pickUpLocation;
  String? landmark;*/

  CollectorRoutesEntityDto(
      {super.id,
      super.route,
      super.routeCode,
      super.collectors,
      super.pickUpLocation});

  factory CollectorRoutesEntityDto.fromJson(Map<String, dynamic> json) {
    return CollectorRoutesEntityDto(
        id: json['id'],
        route: json['route'],
        routeCode: json['routeCode'],
        collectors: json['collectors'],
        pickUpLocation: json['pickUpLocation']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['route'] = route;
    data['routeCode'] = routeCode;
    data['collectors'] = collectors;
    data['pickUpLocation'] = pickUpLocation;
    return data;
  }
}
