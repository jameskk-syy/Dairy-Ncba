import 'package:floor/floor.dart';
import '../../../../../../core/data/dto/add_collection_dto.dart';
import '../../../../../../core/utils/constants.dart';

@Entity(tableName: Constants.kCollectionsTable)
class CollectionsEntity extends AddCollectionDto {

  @PrimaryKey(autoGenerate: true) final int? id;
  const CollectionsEntity(
      { this.id,
        required super.collectorId,
        required super.event,
        required super.farmerNumber,
        required super.latitude,
       required super.longitude,
        required super.paymentStatus,
        required super.quantity,
        required super.routeId,
        required super.session,
        required super.status,
        required super.updatedStatus,
        required super.collectionDate,
      });

}