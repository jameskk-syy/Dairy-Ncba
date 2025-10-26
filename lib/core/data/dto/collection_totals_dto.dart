import 'package:dairytenantapp/feature/collections/domain/model/collection_totals_model.dart';

class CollectionTotals extends CollectionTotalsModel {
  const CollectionTotals({super.message, super.statusCode, super.entity});

  factory CollectionTotals.fromJson(Map<String, dynamic> json) {
    return CollectionTotals(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: List<CollectionTotalsEntity>.from(
        json['entity'].map((item) => CollectionTotalsEntity.fromJson(item)),
      ),
    );
  }
}

class CollectionTotalsEntity extends CollectionTotalsEntityModel {
  const CollectionTotalsEntity({super.date, super.quantity, super.quantityd});

  factory CollectionTotalsEntity.fromJson(Map<String, dynamic> json) =>
      CollectionTotalsEntity(
        date: json['date'],
        quantity:
            json['quantity'] is int
                ? (json['quantity'] as int).toDouble()
                : json['quantity'],
        quantityd:
            json['confirmedQuantity'] is int
                ? (json['confirmedQuantity'] as int).toDouble()
                : json['confirmedQuantity'],
      );
}
