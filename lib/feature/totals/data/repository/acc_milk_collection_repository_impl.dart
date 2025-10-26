import 'package:dairytenantapp/feature/totals/data/dto/total_milk_accumulation_dto.dart';
import 'package:dairytenantapp/feature/totals/domain/model/add_milk_acc_response_model.dart';
import 'package:dairytenantapp/feature/totals/domain/model/totals_collection_history_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network.dart';
import '../../domain/repository/aac_milk_collection_repository.dart';
import '../datasources/milk_accumulation_data_source.dart';

class AccMilkCollectionRepositoryImpl implements AccMilkCollectionRepository {
  final MilkAccumulationDataSource dataSource;
  final NetworkInfo networkInfo;

  AccMilkCollectionRepositoryImpl(this.dataSource, this.networkInfo);

  @override
  Future<Either<Failure, AddMilkAccumulationResponse>> addMilkAccumulation(
    MilkTotalsAccumulationDto requestBody,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await dataSource.addMilkAccumulation(requestBody);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TotalsCollectionHistoryModel>>
  getMilkAccumulationHistory(int collectorId) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await dataSource.getMilkAccumulationHistory(
          collectorId,
        );
        final sortedResult =
            response.entity!
              ..sort((a, b) => b.collectionDate!.compareTo(a.collectionDate!));
        final collectionHistoryModel = TotalsCollectionHistoryModel(
          entity: sortedResult,
          message: response.message,
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
  Future<Either<Failure, TotalsCollectionHistoryModel>>
  getMilkAccumulationHistoryByDate(int collectorId, String date) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await dataSource.getMilkAccumulationHistoryByDate(
          collectorId,
          date,
        );
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalRoutes(
    int collectorId,
    String date,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await dataSource.getMilkAccumulationHistoryByDate(
          collectorId,
          date,
        );
        Set<int?> routeFks = response.entity!.map((e) => e.routeFk).toSet();
        return Right(routeFks.length);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalMilkLts(
    int collectorId,
    String date,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await dataSource.getMilkAccumulationHistoryByDate(
          collectorId,
          date,
        );
        final double? totalMilkLts = response.entity!
            .map((e) => e.milkQuantity)
            .reduce((value, element) => value! + element!);
        return Right(totalMilkLts ?? 0);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }
}
