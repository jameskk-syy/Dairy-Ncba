import '../../../../core/data/dto/add_collection_dto.dart';
import '../datasources/local/entity/collections_entity.dart';

extension AddCollectionDtoMapper on AddCollectionDto {
  CollectionsEntity toCollectionsEntity() {
    return CollectionsEntity(
      collectorId: collectorId,
      event: event,
      farmerNumber: farmerNumber,
      latitude: latitude,
      longitude: longitude,
      paymentStatus: paymentStatus,
      quantity: quantity,
      routeId: routeId,
      session: session,
      status: status,
      updatedStatus: updatedStatus,
      collectionDate: collectionDate,
    );
  }
}





/*
extension CollectionHistoryEntityModelMapper on CollectionHistoryEntityModel {
  CollectionsEntity toEntityModel() {
    return CollectionsEntity(
      id: id,
    );
  }
}*/
