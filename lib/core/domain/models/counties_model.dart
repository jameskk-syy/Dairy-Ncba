import 'package:equatable/equatable.dart';

class CountiesResponseModel extends Equatable {
  String? message;
  int? statusCode;
  List<CountiesEntityModel>? entity;

  CountiesResponseModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props {
    return [message, statusCode, entity];
  }
}

class CountiesEntityModel extends Equatable{
  int? id;
  String? name;
  String? code;
  String? createdAt;

  CountiesEntityModel({this.id, this.name, this.code, this.createdAt});

  @override
  List<Object?> get props {
    return [id, name, code, createdAt];
  }
}