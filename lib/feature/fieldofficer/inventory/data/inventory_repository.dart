import 'package:dairytenantapp/core/network/network.dart';
import 'package:dairytenantapp/feature/fieldofficer/inventory/data/inventory_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../collections/domain/model/custom_resp_model.dart';
import '../../../totals/domain/model/products_model.dart';

abstract class InventoryRepository {
  Future<Either<Failure, ProductsModelResponse>> getAllProducts();
  Future<Either<Failure, CustomResponse>> allocateFeeds(
    int productId,
    int locationId,
    int stock,
  );
  Future<Either<Failure, CustomResponse>> transferStock(
    int sourceId,
    int destinationId,
    int productId,
    int stock,
  );
  Future<Either<Failure, ProductsModelResponse>> getAllFeedAllocations();
}

class InventoryRepositoryImpl implements InventoryRepository {
  final NetworkInfo networkInfo;
  final InventoryRemoteSource inventoryRemoteSource;

  const InventoryRepositoryImpl(this.networkInfo, this.inventoryRemoteSource);

  @override
  Future<Either<Failure, ProductsModelResponse>> getAllProducts() async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        final response = await inventoryRemoteSource.getAllProducts();

        return Right(response);
      } on ServerException catch (e) {
        logger.e(e.toString());
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, CustomResponse>> allocateFeeds(
    int productId,
    int locationId,
    int stock,
  ) async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        final response = await inventoryRemoteSource.allocateFeeds(
          productId,
          locationId,
          stock,
        );

        return Right(response);
      } on ServerException catch (e) {
        logger.e(e.toString());
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, CustomResponse>> transferStock(
    int sourceId,
    int destinationId,
    int productId,
    int stock,
  ) async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        final response = await inventoryRemoteSource.transferStock(
          sourceId,
          destinationId,
          productId,
          stock,
        );

        return Right(response);
      } on ServerException catch (e) {
        logger.e(e.toString());
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, ProductsModelResponse>> getAllFeedAllocations() async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        logger.i("fetching feed allocations ..........");
        final response = await inventoryRemoteSource.getAllFeedAllocations();

        return Right(response);
      } on ServerException catch (e) {
        logger.e(e.toString());
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure("No Internet Connection"));
    }
  }
}
