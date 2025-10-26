
import 'package:equatable/equatable.dart';

class CanResponseModel extends Equatable{
   String? message;
  int? statusCode;
  List<CanResponseEntityModel>? entity;

  CanResponseModel({this.entity, this.message, this.statusCode});
  
  @override

  List<Object?> get props => [entity, message, statusCode];



}

class CanResponseEntityModel extends Equatable {
  int? id;
  String? canNo;
  String? canName;
  double? weight;
  double? deductionWeight;

  CanResponseEntityModel({this.canName, this.canNo, this.deductionWeight, this.id, this.weight});
  
  @override

  List<Object?> get props => [canName, canNo, deductionWeight, id, weight];


}