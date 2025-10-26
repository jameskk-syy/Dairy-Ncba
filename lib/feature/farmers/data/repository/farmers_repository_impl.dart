import 'package:dairytenantapp/core/network/network.dart';
import 'package:dairytenantapp/feature/farmers/data/mappers/mappers.dart';
import 'package:dairytenantapp/feature/farmers/domain/model/farmer_details_model.dart';
import 'package:dairytenantapp/feature/farmers/domain/model/onboard_farmer_response.dart';
import 'package:dairytenantapp/feature/farmers/domain/repository/farmers_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../core/data/datasources/local/datasource/core_local_datasource.dart';
import '../../../../core/data/datasources/remote/core_remote_data_source.dart';
import '../../../../core/data/mappers/mappers.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../collections/domain/model/custom_resp_model.dart';
import '../../domain/model/farmers_response_model.dart';
import '../../domain/model/onboard_farmer_details.dart';
import '../datasources/local/farmers_local_data_source.dart';
import '../datasources/remote/farmers_remote_data_source.dart';

class FarmersRepositoryImpl implements FarmersRepository {
  final FarmersRemoteDataSource remoteDataSource;
  final FarmersLocalDataSource localDataSource;
  final CoreLocalDataSource coreLocalDataSource;
  final NetworkInfo networkInfo;
  final CoreRemoteDataSource coreRemoteDataSource;

  FarmersRepositoryImpl(
    this.remoteDataSource,
    this.networkInfo,
    this.localDataSource,
    this.coreLocalDataSource,
    this.coreRemoteDataSource,
  );

  @override
  Future<Either<Failure, List<FarmersEntityModel>>> getFarmers(
    int collectorId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        var logger = Logger();

        logger.i("GOT HEREEEEEEEEEEEEEEEE   111111111");
        final farmers = await remoteDataSource.getFarmers(collectorId);
        //final sortedFarmers = farmers.entity!..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        farmers.entity!.sort((a, b) => b.farmerNo!.compareTo(a.farmerNo!));
        final farmersResponseModel = FarmersResponseModel(
          entity: farmers.entity!,
          message: farmers.message,
        );
        final results =
            farmersResponseModel.entity!
                .map((e) => fromEntityToDomain(e))
                .toList();
        localDataSource.deleteAllFarmers();
        await localDataSource.insertFarmer(results);
        return Right(farmersResponseModel.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        var logger = Logger();

        logger.i("GOT HEREEEEEEEEEEEEEEEE 2222222222");

        final localData = await localDataSource.getAllFarmers();
        logger.i("farmers retrieved ${localData.length}");
        final farmers = localData.map((e) => toEntity(e)).toList();
        return Right(farmers);
      } on DatabaseException catch (exception) {
        return Left(DatabaseFailure(exception.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<FarmersEntityModel>>> getAllRouteFarmers(
    int routeId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final farmers = await remoteDataSource.getRouteFarmers(routeId);
        //final sortedFarmers = farmers.entity!..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        farmers.entity!.sort((a, b) => b.farmerNo!.compareTo(a.farmerNo!));
        final farmersResponseModel = FarmersResponseModel(
          entity: farmers.entity!,
          message: farmers.message,
        );
        return Right(farmersResponseModel.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<FarmersEntityModel>>> getMccFarmers(
    int mccId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final farmers = await remoteDataSource.getMccFarmers(mccId);
        //final sortedFarmers = farmers.entity!..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        farmers.entity!.sort((a, b) => b.farmerNo!.compareTo(a.farmerNo!));
        final farmersResponseModel = FarmersResponseModel(
          entity: farmers.entity!,
          message: farmers.message,
        );
        // final results = farmersResponseModel.entity!
        //     .map((e) => fromEntityToDomain(e))
        //     .toList();
        // localDataSource.deleteAllFarmers();
        // await localDataSource.insertFarmer(results);
        return Right(farmersResponseModel.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<FarmersEntityModel>>> getRouteFarmers(
    int collectorId,
  ) async {
    // final farmerss = await remoteDataSource.getFarmers(collectorId);
    try {
      final localData = await localDataSource.getRouteFarmers(collectorId);
      final farmers = localData.map((e) => toEntity(e)).toList();
      return Right(farmers);
    } on DatabaseException catch (exception) {
      return Left(DatabaseFailure(exception.message));
    }
  }

  @override
  Future<Either<Failure, CustomResponse>> updateRoute(
    int farmerNo,
    int routeId,
  ) async {
    var logger = Logger();
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.updateRoute(farmerNo, routeId);

        return Right(response);
      } on ServerException catch (e) {
        logger.e(e.toString());
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, FarmerDetailsEntityModel>> getFarmerDetails(
    int farmerNumber,
    /*int collectorId*/
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        var logger = Logger();

        logger.e("GOT HEREEEEEEEEEEEEEEEE   111111111");

        final farmer = await remoteDataSource.getFarmerDetails(
          farmerNumber /* collectorId*/,
        );
        // final farmerData = getFarmerDetailsModel(farmer.entity!);

        // final routes =
        //     coreRemoteDataSource.getCollectorRoutes(getUserData().id!);

        final croutes = await coreLocalDataSource.getAllRoutes();
        // final collectorRoutes = await coreRemoteDataSource.getCollectorRoutes(collectorId)
        final collroutes =
            croutes.map((route) => toRouteEntity(route)).toList();

        // for (var route in routes) {
        //   if (route.id == farmer.entity!.routeId) {
        //     return Right(farmer.entity!);
        //   } else {
        //     throw const ServerException(message: "Farmer not found in your route");
        //   }
        // }
        try {
          // print("here are my routes $collroutes");
          collroutes.firstWhere((route) {
            logger.i(
              "route id from local + ${route.id} ,,,, route id from farmer ${farmer.entity!.routeId}",
            );
            return route.id == farmer.entity!.routeId;
          });
          return Right(farmer.entity!);
        } catch (e) {
          logger.e("Farmer not found in your route");
          throw const ServerException(
            message: "Farmer not found in your route",
          );
        }
        // return Right(farmer.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        var logger = Logger();
        logger.e("GOT HEREEEEEEEEEEEEEEEE 2222222222");
        final localData = await localDataSource.getFarmerByFarmerNo(
          farmerNumber,
        );
        if (localData != null) {
          final farmer = toFarmerDetailsModel(localData);
          return Right(farmer);
        } else {
          return const Left(
            DatabaseFailure(
              'Farmer not found. Connect to internet and try again',
            ),
          );
        }
      } on DatabaseException catch (exception) {
        return Left(DatabaseFailure(exception.message));
      }
    }
  }

  @override
  Future<Either<Failure, FarmerDetailsEntityModel>> getFarmerInfo(
    int farmerNumber,
    /*int collectorId*/
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        var logger = Logger();

        logger.e("retrieve farmer information");

        final farmer = await remoteDataSource.getFarmerDetails(
          farmerNumber /* collectorId*/,
        );
        return Right(farmer.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, OnBoardFarmerResponseModel>> addFarmer(
    FarmerOnboardRequestModel farmer,
  ) async {
    final log = Logger();
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.addFarmer(farmer);
        if (response.statusCode == 201) {
          log.i(response.message!);
          log.i(response.entity!.farmerNo);
          log.i(response);
          final onBoardFarmerResponseModel = OnBoardFarmerResponseModel(
            message: response.message!,
            statusCode: response.statusCode,
            entity: response.entity!,
          );
          print("$onBoardFarmerResponseModel");
          return Right(onBoardFarmerResponseModel);
        } else {
          return Left(ServerFailure(response.message!));
        }
      } on ServerException catch (e) {
        log.e(e.message);
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }
}
