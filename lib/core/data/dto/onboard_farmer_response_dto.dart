
import '../../../feature/farmers/domain/model/onboard_farmer_response.dart';

class OnBoardFarmerResponseDto extends OnBoardFarmerResponseModel{
  /*String? message;
  int? statusCode;
  Entity? entity;*/

  const OnBoardFarmerResponseDto({super.message, super.statusCode, super.entity});

  factory OnBoardFarmerResponseDto.fromJson(Map<String, dynamic> json) {
    return OnBoardFarmerResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null ? Entity.fromJson(json['entity']) : null,
    );
  }
}

class Entity extends OnBoardFarmerEntityModel {
  /*int? farmerNumber;
  String? userName;*/

  const Entity({super.farmerNo, super.userName});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      farmerNo: json['farmerNo'],
      userName: json['username'],
    );
  }
}