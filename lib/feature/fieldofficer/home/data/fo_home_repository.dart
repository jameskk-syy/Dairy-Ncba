import 'package:http/http.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../../../feature/farmers/domain/model/deliveries_dto.dart';
import '../../../../feature/fieldofficer/home/data/fo_home_datasource.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class FOHomeRepository {
  Future<Either<Failure, DeliveryResponseDto>> getDeliveries(
      int farmerNo, String from, String to);
  Future<Either<Failure, Response>> getStatement(
      int farmerNo, String from, String to);
  Future<Either<Failure, Response>> getAllocationHistory(int month, String year);
  Future<Either<Failure, Response>> getRouteSummaryReport(int routeId, int month, String year);
}

class FOHomeRepositoryImpl implements FOHomeRepository {
  final NetworkInfo networkInfo;
  final FOHomeRemoteSource foHomeRemoteSource;

  const FOHomeRepositoryImpl(this.networkInfo, this.foHomeRemoteSource);

  @override
  Future<Either<Failure, DeliveryResponseDto>> getDeliveries(
      int farmerNo, String from, String to) async {
    if (await networkInfo.isConnected()) {
      try {
        final response =
            await foHomeRemoteSource.getDeliveries(farmerNo, from, to);

        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("Check your internet"));
    }
  }

  @override
  Future<Either<Failure, Response>> getStatement(
      int farmerNo, String from, String to) async {
    if (await networkInfo.isConnected()) {
      try {
        final response =
            await foHomeRemoteSource.getStatement(farmerNo, from, to);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("Check your connection"));
    }
  }

  @override
  Future<Either<Failure, Response>> getAllocationHistory(
      int month, String year) async {
    if (await networkInfo.isConnected()) {
      try {
        final response =
            await foHomeRemoteSource.getAllocationHistory(month, year);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("Check your internet connection"));
    }
  }

    @override
  Future<Either<Failure, Response>> getRouteSummaryReport(
      int routeId, int month, String year) async {
    if (await networkInfo.isConnected()) {
      try {
        final response =
            await foHomeRemoteSource.getRouteReport(routeId, month, year);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("Check your internet connection"));
    }
  }
}
