import 'package:equatable/equatable.dart';

class MonthlyTotalsModel extends Equatable {
  final String? message;
  final int? statusCode;
  final List<MonthlyTotalsModelEntity>? entity;

  const MonthlyTotalsModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class MonthlyTotalsModelEntity extends Equatable {
  final double? collected;
  final double? supply;

  const MonthlyTotalsModelEntity({this.collected, this.supply});

  @override
  List<Object?> get props => [collected, supply];
}
