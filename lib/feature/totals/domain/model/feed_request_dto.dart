// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FeedRequestDto extends Equatable {
  final int? farmerNo;
  final String? farmerName;
  final int? locationId;
  final int? routeFk;
  final int? productId;
  final int? quantity;
  final double? amount;
  final double? price;
  final String? productName;
  final String? type;
  final String? comments;
  const FeedRequestDto({
    this.farmerNo,
    this.farmerName,
    this.locationId,
    this.routeFk,
    this.productId,
    this.quantity,
    this.amount,
    this.price,
    this.productName,
    this.type,
    this.comments,
  });

  @override
  List<Object?> get props {
    return [
      farmerNo,
      farmerName,
      locationId,
      routeFk,
      productId,
      quantity,
      amount,
      price,
      productName,
      type,
      comments,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'farmerNo': farmerNo,
      'farmerName': farmerName,
      'locationId': locationId,
      'routeFk': routeFk,
      'productId': productId,
      'quantity': quantity,
      'amount': amount,
      'price': price,
      'productName': productName,
      'type': type,
      'comments': comments,
    };
  }

  String toJson() => json.encode(toMap());
}
