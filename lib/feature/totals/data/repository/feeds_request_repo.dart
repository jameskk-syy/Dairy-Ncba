import 'package:dairytenantapp/core/errors/exceptions.dart';
import 'package:dairytenantapp/core/network/network.dart';
import 'package:dairytenantapp/feature/totals/data/datasources/feeds_request_source.dart';
import 'package:dairytenantapp/feature/totals/domain/model/product_category.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../collections/domain/model/custom_resp_model.dart';
import '../../domain/model/feed_request_dto.dart';
import '../../domain/model/feeds_requests_model.dart';
import '../../domain/model/products_model.dart';

abstract class FeedsRequestRepository {
  Future<Either<Failure, ProductsModelResponse>> getAllProducts(int locationId);
  Future<Either<Failure, ProductCategoryResponse>> getAllCategories();
  Future<Either<Failure, CustomResponse>> addFeedsRequest(
    FeedRequestDto feedRequestDto,
  );
  Future<Either<Failure, CustomResponse>> confirmFeedsRequest(
    int id,
    String status,
  );

  Future<Either<Failure, AllFeedsRequestModelResponse>> getAllFeedsRequests(
    int locationId,
    int month,
    String year,
  );
}

class FeedsRequestRepoImpl implements FeedsRequestRepository {
  final FeedsRequestSource feedsRequestSource;
  final NetworkInfo networkInfo;

  FeedsRequestRepoImpl(this.feedsRequestSource, this.networkInfo);

  @override
  Future<Either<Failure, ProductCategoryResponse>> getAllCategories() async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        final response = await feedsRequestSource.getAllCategories();
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
  Future<Either<Failure, ProductsModelResponse>> getAllProducts(
    int locationId,
  ) async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      print("location id in repo $locationId");
      try {
        final response = await feedsRequestSource.getAllProducts(locationId);

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
  Future<Either<Failure, CustomResponse>> addFeedsRequest(
    FeedRequestDto feedRequestDto,
  ) async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        final response = await feedsRequestSource.addFeedsRequest(
          feedRequestDto,
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
  Future<Either<Failure, CustomResponse>> confirmFeedsRequest(
    int id,
    String status,
  ) async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        final response = await feedsRequestSource.confirmFeedsRequest(
          id,
          status,
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
  Future<Either<Failure, AllFeedsRequestModelResponse>> getAllFeedsRequests(
    int locationId,
    int month,
    String year,
  ) async {
    final logger = Logger();

    if (await networkInfo.isConnected()) {
      try {
        final response = await feedsRequestSource.getAllFeedsRequests(
          locationId,
          month,
          year,
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
}
