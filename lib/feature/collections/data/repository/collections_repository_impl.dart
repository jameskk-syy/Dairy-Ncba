import 'package:dairytenantapp/core/data/dto/add_collection_dto.dart';
import 'package:dairytenantapp/core/data/dto/collection_response.dart';
import 'package:dairytenantapp/core/network/network.dart';
import 'package:dairytenantapp/feature/collections/data/mappers/mappers.dart';
import 'package:dairytenantapp/feature/collections/domain/model/monthly_totals_model.dart';
import 'package:dairytenantapp/feature/collections/domain/repository/collections_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/model/collection_history_model.dart';
import '../../domain/model/collection_totals_model.dart';
import '../../domain/model/custom_resp_model.dart';
import '../datasources/local/collections_local_data_source.dart';
import '../datasources/local/entity/collections_entity.dart';
import '../datasources/remote/collections_remote_data_source.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  final NetworkInfo networkInfo;
  final CollectionsRemoteDataSource remoteDataSource;
  final CollectionsLocalDataSource localDataSource;

  CollectionsRepositoryImpl(
    this.networkInfo,
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, CollectionHistoryModel>> getCollectionHistory(
    int collectorId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.getCollectionHistory(collectorId);
        final sortedResult =
            result.entity!
              ..sort((a, b) => b.collectionDate!.compareTo(a.collectionDate!));
        final collectionHistoryModel = CollectionHistoryModel(
          entity: sortedResult,
          message: result.message,
        );
        return Right(collectionHistoryModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CollectionTotalsModel>> getCollectorsDailyTotals(
    int collectorId,
    int year,
    int month,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.getCollectorsDailyTotals(
          collectorId,
          year,
          month,
        );
        final collectionTotalsModel = CollectionTotalsModel(
          entity: result.entity,
          message: result.message,
        );
        return Right(collectionTotalsModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure("No internet Connection"));
    }
  }

  @override
  Future<Either<Failure, CollectionTotalsModel>> getCollectorsDailySupply(
    int year,
    int month,
    int collectorId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.getCollectorsDailySupply(
          collectorId,
          year,
          month,
        );
        final collectionTotalsModel = CollectionTotalsModel(
          entity: result.entity,
          message: result.message,
        );
        return Right(collectionTotalsModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure("No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, MonthlyTotalsModel>> getMonthlyTotals(
    int collectorId,
    int month,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.getMonthlyTotals(
          month,
          collectorId,
        );
        final monthlyTotalsModel = MonthlyTotalsModel(
          message: result.message,
          entity: result.entity,
          statusCode: result.statusCode,
        );
        return Right(monthlyTotalsModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ServerFailure("No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, CollectionResponse>> addCollection(
    AddCollectionDto collection,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.addCollection(collection);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final result = await localDataSource.insertCollection(
          collection.toCollectionsEntity(),
        );
        return Right(result);
      } on DatabaseException catch (e) {
        return Left(DatabaseFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, CustomResponse>> returnDelivery(
    int collectionId,
  ) async {
    if (await networkInfo.isConnected()) {
      final logger = Logger();

      logger.i("sending return request ======>");
      try {
        final result = await remoteDataSource.returnDelivery(collectionId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("No internet connection"));
    }
  }

  @override
  Future<Either<Failure, CollectionHistoryModel>> getCollectionsByDate(
    int collectorId,
    String date,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.getCollectionsByDate(
          collectorId,
          date,
        );
        final sortedResult =
            result.entity!
              ..sort((a, b) => b.collectionDate!.compareTo(a.collectionDate!));
        final collectionHistoryModel = CollectionHistoryModel(
          entity: sortedResult,
          message: result.message,
        );
        return Right(collectionHistoryModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CollectionHistoryModel>>
  getFarmerCollectionsByDateRange(
    int collectorId,
    String farmerNo,
    String startDate,
    String endDate,
    String session,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final result = await remoteDataSource.getFarmerCollectionsByDateRange(
          collectorId,
          farmerNo,
          startDate,
          endDate,
          session,
        );
        final sortedResult =
            result.entity!
              ..sort((a, b) => b.collectionDate!.compareTo(a.collectionDate!));
        final collectionHistoryModel = CollectionHistoryModel(
          entity: sortedResult,
          message: result.message,
        );
        return Right(collectionHistoryModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CollectionsEntity>>>
  getPendingCollections() async {
    try {
      final result = await localDataSource.getAllCollections();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CollectionResponse>> syncCollection() async {
    if (await networkInfo.isConnected()) {
      try {
        final collections = await localDataSource.getAllCollections();
        // final count = collections.length;
        for (var collection in collections) {
          try {
            await remoteDataSource.syncCollection(collection).then((value) {
              if (value.statusCode == 201) {
                localDataSource.deleteCollectionById(collection.id!);
              } else if (value.statusCode == 406) {
                localDataSource.deleteCollectionById(collection.id!);
              } else {
                return Left(ServerFailure(value.message));
              }
            });
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          }
        }
        return Right(
          CollectionResponse(message: 'Synced successfully', statusCode: 201),
        );
        /*final result = await remoteDataSource.addCollection(collection);
        await localDataSource.deleteCollectionById(collection.id!);
        return Right(result);*/
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  /*@override
  Future<Either<Failure, CollectionHistoryModel>> getDayCollection(int collectorId, String date) async {
    if(await networkInfo.isConnected()){
      try{
        final result = await remoteDataSource.getDayCollection(collectorId, date);
        final sortedResult = result.entity!..sort((a, b) => b.collectionDate!.compareTo(a.collectionDate!));
        final collectionHistoryModel = CollectionHistoryModel(entity: sortedResult, message: result.message);
        return Right(collectionHistoryModel);
      } on ServerException catch (e){
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }*/
}
