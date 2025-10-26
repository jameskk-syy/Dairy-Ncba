import 'package:equatable/equatable.dart';

class CollectionTotalsModel extends Equatable {
  final String? message;
  final int? statusCode;
  final List<CollectionTotalsEntityModel>? entity;

  const CollectionTotalsModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class CollectionTotalsEntityModel extends Equatable {
  final String? date;
  final double? quantity;
  final double? quantityd;

  const CollectionTotalsEntityModel({this.date, this.quantity, this.quantityd});

  @override
  List<Object?> get props => [date, quantity, quantityd];
}
