

import '../../domain/models/sub_counties_model.dart';

class SubCountiesResponseDto extends SubCountiesResponseModel {


  SubCountiesResponseDto({super.message, super.statusCode, super.entity});

  factory SubCountiesResponseDto.fromJson(Map<String, dynamic> json) {
    return SubCountiesResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null ? (json['entity'] as List).map((i) => SubCountiesEntityDto.fromJson(i)).toList() : null,
    );
  }

}

class SubCountiesEntityDto extends SubCountiesEntityModel {


  SubCountiesEntityDto({super.id, super.subcounty, super.county, super.wardCount});

  factory SubCountiesEntityDto.fromJson(Map<String, dynamic> json) {
    return SubCountiesEntityDto(
      id: json['id'],
      subcounty: json['subcounty'],
      county: json['county'],
      wardCount: json['wardCount'],
    );
  }
}
