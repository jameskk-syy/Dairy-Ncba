
import 'package:equatable/equatable.dart';

class OnBoardFarmerResponseModel extends Equatable {
  final String? message;
  final int? statusCode;
  final OnBoardFarmerEntityModel? entity;

  const OnBoardFarmerResponseModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];


}

class OnBoardFarmerEntityModel extends Equatable {
  final int? farmerNo;
  final String? userName;

  const OnBoardFarmerEntityModel({this.farmerNo, this.userName});

  @override
  List<Object?> get props {
    return [farmerNo, userName];
  }
}