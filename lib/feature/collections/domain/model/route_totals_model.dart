// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class RouteTotalsModel extends Equatable {
  final String? route;
  final double? quantity;

  const RouteTotalsModel({
    this.route,
    this.quantity,
  });

  @override
  List<Object?> get props => [route, quantity];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'route': route,
      'quantity': quantity,
    };
  }

  factory RouteTotalsModel.fromMap(Map<String, dynamic> map) {
    return RouteTotalsModel(
      route: map['route'] != null ? map['route'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteTotalsModel.fromJson(String source) => RouteTotalsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
