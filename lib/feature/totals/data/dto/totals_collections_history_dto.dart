

import '../../domain/model/totals_collection_history_model.dart';

class TotalsCollectionHistoryDto extends TotalsCollectionHistoryModel {

  const TotalsCollectionHistoryDto({super.message, super.statusCode, super.entity});

  factory TotalsCollectionHistoryDto.fromJson(Map<String, dynamic> json) {
    return TotalsCollectionHistoryDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null ? (json['entity'] as List).map((i) => Entity.fromJson(i)).toList() : null,
    );
  }

}

class Entity extends TotalsCollectionHistoryEntity {

  const Entity(
      {super.id,
        super.milkQuantity,
        super.amount,
        super.routeFk,
        super.route,
        super.collectorId,
        super.session,
        super.collectionDate,
        super.createdAt,
        super.deletedFlag,
        super.deletedOn});

 factory Entity.fromJson(Map<String, dynamic> json) {
   return Entity(
     id: json['id'],
     milkQuantity: json['milkQuantity'],
     amount: json['amount'],
     routeFk: json['routeFk'],
     route: json['route'],
     collectorId: json['collectorId'],
     session: json['session'],
     collectionDate: json['collectionDate'],
     createdAt: json['createdAt'],
     deletedFlag: json['deletedFlag'],
     deletedOn: json['deletedOn'],
    );
    /*id = json['id'];
    milkQuantity = json['milkQuantity'];
    amount = json['amount'];
    routeFk = json['routeFk'];
    route = json['route'];
    collectorId = json['collectorId'];
    session = json['session'];
    collectionDate = json['collectionDate'];
    createdAt = json['createdAt'];
    deletedFlag = json['deletedFlag'];
    deletedOn = json['deletedOn'];*/
  }
}
