import 'package:dairytenantapp/core/data/datasources/local/datasource/local/entity/routes_entity.dart';
import 'package:dairytenantapp/core/data/dto/collectors_response_dto.dart';
import 'package:dairytenantapp/core/data/dto/pickup_location.dart';
import 'package:dairytenantapp/core/domain/models/collector_routes_model.dart';
import 'package:dairytenantapp/core/domain/models/counties_model.dart';
import 'package:dairytenantapp/core/domain/models/sub_counties_model.dart';
import 'package:dairytenantapp/core/errors/exceptions.dart';
import 'package:dairytenantapp/core/network/network.dart';
import 'package:dartz/dartz.dart';

import 'package:dairytenantapp/core/errors/failures.dart';

import 'package:dairytenantapp/core/domain/models/can_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../domain/models/routes_model.dart';
import '../../domain/repository/core_repository.dart';
import '../datasources/local/datasource/core_local_datasource.dart';
import '../datasources/remote/core_remote_data_source.dart';
import '../mappers/mappers.dart';

class CoreRepositoryImpl implements CoreRepository {
  final CoreRemoteDataSource remoteDataSource;
  final CoreLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CoreRepositoryImpl(
    this.remoteDataSource,
    this.networkInfo,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, CanResponseModel>> getCanList() async {
    final log = Logger();
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getCanList();
        if (kDebugMode) {
          log.i(response);
        }
        return Right(response);
      } on ServerException catch (e) {
        if (kDebugMode) {
          log.e(e.message);
        }
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CountiesResponseModel>> getCounties() async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getCounties();
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SubCountiesResponseModel>> getSubCounties() async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getSubCounties();
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PickupLocationResponseDto>>
  getCollectorPickupLocations(int collectorId) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getCollectorPickupLocations(
          collectorId,
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
  Future<Either<Failure, RoutesResponseModel>> getRoutes() async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getRoutes();
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CollectorRoutesEntityResponse>>>
  getCollectorRoutes(int collectorId) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getCollectorRoutes(collectorId);
        final routesModel = CollectorRoutesModel(
          entity: response.entity,
          statusCode: response.statusCode,
          message: response.message,
        );
        final routes = routesModel.entity!.map((e) => fromDomain(e)).toList();
        localDataSource.deleteAllRoutes();
        await localDataSource.insertRoutes(routes);
        return Right(response.entity!);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      //return const Left(ServerFailure('No internet connection'));
      try {
        final response = await localDataSource.getAllRoutes();
        final routes = response.map((e) => toRouteEntity(e)).toList();
        return Right(routes);
      } on DatabaseException catch (exception) {
        return Left(DatabaseFailure(exception.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<RoutesEntity>>> getMyRoutes(
    int collectorId,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getCollectorRoutes(collectorId);
        final routesModel = CollectorRoutesModel(
          entity: response.entity,
          statusCode: response.statusCode,
          message: response.message,
        );
        final routes = routesModel.entity!.map((e) => fromDomain(e)).toList();
        // localDataSource.deleteAllRoutes();
        // await localDataSource.insertRoutes(routes);
        return Right(routes);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
      // try {
      //   final response = await localDataSource.getAllRoutes();
      //   final routes = response.map((e) => toRouteEntity(e)).toList();
      //   return Right(routes);
      // } on DatabaseException catch (exception) {
      //   return Left(DatabaseFailure(exception.message));
      // }
    }
  }

  @override
  Future<Either<Failure, List<UserData>>> getMilkCollectors() async {
    if (await networkInfo.isConnected()) {
      try {
        final response = await remoteDataSource.getMilkCollectors();
        return Right(response.userData ?? []);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }
}
