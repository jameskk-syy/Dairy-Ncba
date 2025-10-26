

import '../../domain/models/counties_model.dart';

class CountiesResponseDto extends CountiesResponseModel {


  CountiesResponseDto({super.message, super.statusCode, super.entity});

  factory CountiesResponseDto.fromJson(Map<String, dynamic> json) {
    return CountiesResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null ? (json['entity'] as List).map((i) => CountiesEntityDto.fromJson(i)).toList() : null,
    );
  }

}

class CountiesEntityDto  extends CountiesEntityModel{

  CountiesEntityDto({super.id, super.name, super.code, super.createdAt});

 factory CountiesEntityDto.fromJson(Map<String, dynamic> json) {
   return CountiesEntityDto(
     id: json['id'],
     name: json['name'],
     code: json['code'],
     createdAt: json['createdAt'],
   );
  }

}
