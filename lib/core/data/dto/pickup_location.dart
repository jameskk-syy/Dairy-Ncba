import '../../domain/models/pickup_location_model.dart';

class PickupLocationResponseDto extends PickupLocationModel {

  PickupLocationResponseDto({super.message, super.statusCode, super.entity});

  factory PickupLocationResponseDto.fromJson(Map<String, dynamic> json) {
    return PickupLocationResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null ? (json['entity'] as List).map((i) => PickupLocationEntityDto.fromJson(i)).toList() : null,
    );
  }

}

class PickupLocationEntityDto  extends PickupLocationEntityModel{

  PickupLocationEntityDto({super.name, super.id, super.ward, super.landmark});

  factory PickupLocationEntityDto.fromJson(Map<String, dynamic> json) {
    return PickupLocationEntityDto(
      name: json['name'],
      id: json['id'],
      ward: json['ward'],
      landmark: json['landmark'],
    );
  }

}
