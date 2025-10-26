

import 'package:equatable/equatable.dart';

class PickupLocationModel extends Equatable{
  String? message;
  int? statusCode;
  List<PickupLocationEntityModel>? entity;

  PickupLocationModel({this.entity, this.message, this.statusCode});

  @override

  List<Object?> get props => [entity, message, statusCode];
}

class PickupLocationEntityModel extends Equatable {
  String? name;
  int? id;
  String? ward;
  String? landmark;

  PickupLocationEntityModel({this.name, this.id, this.ward, this.landmark});

  @override

  List<Object?> get props => [name, id, ward, landmark];
}