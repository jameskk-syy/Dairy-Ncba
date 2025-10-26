

import 'package:equatable/equatable.dart';

class SubCountiesResponseModel extends Equatable{
  String? message;
  int? statusCode;
  List<SubCountiesEntityModel>? entity;

  SubCountiesResponseModel({this.entity, this.message, this.statusCode});

  @override
  List<Object?> get props {
    return [entity, message, statusCode];
  }
}

class SubCountiesEntityModel extends Equatable {
  int? id;
  String? subcounty;
  String? county;
  String? wardCount;

  SubCountiesEntityModel({this.id, this.subcounty, this.county, this.wardCount});

  @override
  List<Object?> get props {
    return [id, subcounty, county, wardCount];
  }
}