
import '../../domain/models/can_response_model.dart';

class CanResponseDto extends CanResponseModel {
 

  CanResponseDto({super.message, super.statusCode, super.entity});

  factory CanResponseDto.fromJson(Map<String, dynamic> json) {
    return CanResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null ? (json['entity'] as List).map((i) => CanReponseEntityDto.fromJson(i)).toList() : null,
    );
  }

  
}

class CanReponseEntityDto extends CanResponseEntityModel {
  

  CanReponseEntityDto({super.id, super.canNo, super.canName, super.weight, super.deductionWeight});

  factory CanReponseEntityDto.fromJson(Map<String, dynamic> json){
    return CanReponseEntityDto(
      id: json['id'],
      canNo: json['canNo'],
      canName: json['canName'],
      weight: json['weight'],
      deductionWeight: json['deductionWeight']
    );
  }

  
}
