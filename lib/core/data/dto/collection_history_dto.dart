

import '../../../feature/collections/domain/model/collection_history_model.dart';
class CollectionHistoryDto extends CollectionHistoryModel  {


  const CollectionHistoryDto({super.message, super.statusCode, super.entity});

   factory CollectionHistoryDto.fromJson(Map<String, dynamic> json) => CollectionHistoryDto(
    message: json["message"],
    statusCode: json["statusCode"],
    entity: List<CollectionHistoryEntity>.from(json["entity"].map((x) => CollectionHistoryEntity.fromJson(x))));


}

class CollectionHistoryEntity extends CollectionHistoryEntityModel {


  const CollectionHistoryEntity(
      {super.id,
        super.date,
        super.session,
        super.farmerNo,
        super.quantity,
        super.originalQuantity,
        super.currentPrice,
        super.canNo,
        super.ward,
        super.farmer,
        super.collectionDate,
        super.route,
        super.pickUpLocation,
        super.amount,
        super.collector,
        super.event,
        super.paymentStatus,
        super.collectionCode,
        super.firstName,
        super.lastName,
        super.productType,
        super.farmerId,
        super.updateStatus});

  factory CollectionHistoryEntity.fromJson(Map<String, dynamic> json) => CollectionHistoryEntity(
    id: json["id"],
    date: json["date"],
    session: json["session"],
    farmerNo: json["farmer_no"],
    quantity: json["quantity"],
    originalQuantity: json["originalQuantity"],
    currentPrice: json["currentPrice"],
    canNo: json["canNo"],
    ward: json["ward"],
    farmer: json["farmer"],
    collectionDate: json["collection_date"],
    route: json["route"],
    pickUpLocation: json["pickUpLocation"],
    amount: json["amount"],
    collector: json["collector"],
    event: json["event"],
    paymentStatus: json["paymentStatus"],
    collectionCode: json["collectionNumber"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    productType: json["productType"],
    farmerId: json["farmerId"],
    updateStatus: json["updateStatus"],
  );

}
