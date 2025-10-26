import 'package:dairytenantapp/core/network/network.dart';
import 'package:dairytenantapp/feature/fieldofficer/mccs/data/mcc_datasource.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/dto/pickup_location.dart';
import '../../../../core/domain/models/routes_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../domain/route_totals_dto.dart';

abstract class MccRepository {
  Future<Either<Failure, PickupLocationResponseDto>> getPickupLocations();
  Future<Either<Failure, RoutesResponseModel>> getMccRoutes(int mccId);
  Future<Either<Failure, RouteSummaryResponseDto>> getRouteSummary(
    int routeId,
    int month,
    String year,
  );
}

class MccRepositoryImpl implements MccRepository {
  final NetworkInfo networkInfo;
  final MccRemoteSource mccRemoteSource;

  MccRepositoryImpl(this.networkInfo, this.mccRemoteSource);

  @override
  Future<Either<Failure, PickupLocationResponseDto>>
  getPickupLocations() async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await mccRemoteSource.getPickupLocations();
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, RoutesResponseModel>> getMccRoutes(int mccId) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await mccRemoteSource.getMccRoutes(mccId);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, RouteSummaryResponseDto>> getRouteSummary(
    int routeId,
    int month,
    String year,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await mccRemoteSource.getRouteSummary(
          routeId,
          month,
          year,
        );
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }
}
