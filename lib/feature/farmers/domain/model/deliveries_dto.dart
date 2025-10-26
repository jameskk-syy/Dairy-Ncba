// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class DeliveryResponseDto extends Equatable {
  final int? statusCode;
  final String? message;
  final List<Delivery>? deliveries;

  const DeliveryResponseDto({this.statusCode, this.message, this.deliveries});

  factory DeliveryResponseDto.fromJson(Map<String, dynamic> map) {
    List<dynamic> payload = map['entity'] ?? [];
    List<Delivery> deliveries = payload
        .map((delivery) => Delivery.fromMap(delivery as Map<String, dynamic>))
        .toList();
    return DeliveryResponseDto(
        statusCode: map['statusCode'],
        message: map['message'],
        deliveries: deliveries);
  }

  @override
  List<Object?> get props => [statusCode, message, deliveries];
}

class Delivery extends Equatable {
  final double? quantity;
  final String? date;

  const Delivery({this.quantity, this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'date': date,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Delivery.fromJson(String source) =>
      Delivery.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [quantity, date];
}
