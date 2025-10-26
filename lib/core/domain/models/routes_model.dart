
import 'package:equatable/equatable.dart';

class RoutesResponseModel extends Equatable {
  String? message;
  int? statusCode;
  List<RoutesEntityModel>? entity;

  RoutesResponseModel({this.entity, this.message, this.statusCode});

  @override
  List<Object?> get props {
    return [entity, message, statusCode];
  }
}

class RoutesEntityModel extends Equatable {
  int? id;
  String? route;
  String? routeCode;
  List<CollectorsEntityModel>? collectors;

  RoutesEntityModel({this.id, this.route, this.routeCode, this.collectors});

  @override
  List<Object?> get props {
    return [id, route, routeCode, collectors];
  }
}

class CollectorsEntityModel extends Equatable {
  int? id;
  String? name;

  CollectorsEntityModel({this.id, this.name});

  @override
  List<Object?> get props {
    return [id, name];
  }
}