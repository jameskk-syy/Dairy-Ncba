// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class RouteSummaryResponseDto extends Equatable {
  final String? message;
  final int? statusCode;
  final List<RouteSummaryModel>? routeList;

  const RouteSummaryResponseDto({
    this.message,
    this.statusCode,
    this.routeList,
  });

  factory RouteSummaryResponseDto.fromJson(Map<String, dynamic> map) {
    final List<dynamic> routes = map['entity'] ?? [];
    final List<RouteSummaryModel> routesList = routes
        .map(
            (route) => RouteSummaryModel.fromMap(route as Map<String, dynamic>))
        .toList();
    return RouteSummaryResponseDto(
        message: map['message'],
        statusCode: map['statusCode'],
        routeList: routesList);
  }

  @override
  List<Object?> get props => [message, statusCode, routeList];
}

class RouteSummaryModel extends Equatable {
  final String? date;
  final double? quantity;

  const RouteSummaryModel({
    this.date,
    this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'quantity': quantity,
    };
  }

  factory RouteSummaryModel.fromMap(Map<String, dynamic> map) {
    return RouteSummaryModel(
      date: map['date'] != null ? map['date'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteSummaryModel.fromJson(String source) =>
      RouteSummaryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [date, quantity];
}
