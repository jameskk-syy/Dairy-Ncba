
import 'package:equatable/equatable.dart';

class CollectionHistoryModel extends Equatable {
  final String? message;
  final int? statusCode;
  final List<CollectionHistoryEntityModel>? entity;

  const CollectionHistoryModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class CollectionHistoryEntityModel extends Equatable {
  final int? id;
  final String? date;
  final String? session;
  final int? farmerNo;
  final double? quantity;
  final double? originalQuantity;
  final double? currentPrice;
  final String? canNo;
  final String? ward;
  final String? farmer;
  final String? collectionDate;
  final String? route;
  final String? pickUpLocation;
  final double? amount;
  final String? collector;
  final String? event;
  final String? paymentStatus;
  final String? collectionCode;
  final String? firstName;
  final String? lastName;
  final String? productType;
  final int? farmerId;
  final String? updateStatus;

  const CollectionHistoryEntityModel(
      {this.id,
        this.date,
        this.session,
        this.farmerNo,
        this.quantity,
        this.originalQuantity,
        this.currentPrice,
        this.canNo,
        this.ward,
        this.farmer,
        this.collectionDate,
        this.route,
        this.pickUpLocation,
        this.amount,
        this.collector,
        this.event,
        this.paymentStatus,
        this.collectionCode,
        this.firstName,
        this.lastName,
        this.productType,
        this.farmerId,
        this.updateStatus});

  @override
  List<Object?> get props => [
    id,
    date,
    session,
    farmerNo,
    quantity,
    originalQuantity,
    currentPrice,
    canNo,
    ward,
    farmer,
    collectionDate,
    route,
    pickUpLocation,
    amount,
    collector,
    event,
    paymentStatus,
    collectionCode,
    firstName,
    lastName,
    productType,
    farmerId,
    updateStatus
  ];
}