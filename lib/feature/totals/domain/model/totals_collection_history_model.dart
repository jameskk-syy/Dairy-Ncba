

import 'package:equatable/equatable.dart';

class TotalsCollectionHistoryModel extends Equatable {
  final String? message;
  final int? statusCode;
  final List<TotalsCollectionHistoryEntity>? entity;

  const TotalsCollectionHistoryModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class TotalsCollectionHistoryEntity extends Equatable {
  final int? id;
  final double? milkQuantity;
  final double? amount;
  final int? routeFk;
  final String? route;
  final int? collectorId;
  final String? session;
  final String? collectionDate;
  final String? createdAt;
  final String? deletedFlag;
  final String? deletedOn;

  const TotalsCollectionHistoryEntity(
      {this.id,
      this.milkQuantity,
      this.amount,
      this.routeFk,
      this.route,
      this.collectorId,
      this.session,
      this.collectionDate,
      this.createdAt,
      this.deletedFlag,
      this.deletedOn});
  @override
  List<Object?> get props => [
        id,
        milkQuantity,
        amount,
        routeFk,
        route,
        collectorId,
        session,
        collectionDate,
        createdAt,
        deletedFlag,
        deletedOn
      ];
}