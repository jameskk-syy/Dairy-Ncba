import 'package:dairytenantapp/feature/collections/domain/model/collection_totals_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/data/dto/add_collection_dto.dart';
import '../../../../core/data/dto/collection_response.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/local/entity/collections_entity.dart';
import '../model/collection_history_model.dart';
import '../model/monthly_totals_model.dart';
import '../model/custom_resp_model.dart';

abstract class CollectionsRepository {
  Future<Either<Failure, CollectionHistoryModel>> getCollectionHistory(
    int collectorId,
  );
  Future<Either<Failure, CollectionHistoryModel>> getCollectionsByDate(
    int collectorId,
    String date,
  );
  Future<Either<Failure, CustomResponse>> returnDelivery(int collectionId);
  Future<Either<Failure, CollectionHistoryModel>>
  getFarmerCollectionsByDateRange(
    int collectorId,
    String farmerNo,
    String startDate,
    String endDate,
    String session,
  );
  Future<Either<Failure, CollectionResponse>> addCollection(
    AddCollectionDto collection,
  );
  Future<Either<Failure, List<CollectionsEntity>>> getPendingCollections();
  Future<Either<Failure, CollectionResponse>> syncCollection();

  Future<Either<Failure, CollectionTotalsModel>> getCollectorsDailyTotals(
    int collectorId,
    int month,
    int year,
  );
  Future<Either<Failure, CollectionTotalsModel>> getCollectorsDailySupply(
    int year,
    int month,
    int collectorId,
  );
  Future<Either<Failure, MonthlyTotalsModel>> getMonthlyTotals(
    int collectorId,
    int month,
  );
  // Future<Either<Failure, CollectionHistoryModel>> getDayCollection(int collectorId, String date);
}
