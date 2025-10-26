import 'package:dairytenantapp/feature/collections/domain/model/custom_resp_model.dart';
import 'package:dairytenantapp/feature/totals/domain/model/products_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';

abstract class InventoryRemoteSource {
  Future<ProductsModelResponse> getAllProducts();
  Future<CustomResponse> allocateFeeds(
    int productId,
    int locationId,
    int stock,
  );
  Future<CustomResponse> transferStock(
    int sourceId,
    int destinationId,
    int productId,
    int stock,
  );
  Future<ProductsModelResponse> getAllFeedAllocations();
}

class InventoryRemoteSourceImpl implements InventoryRemoteSource {
  final Dio dio;

  const InventoryRemoteSourceImpl(this.dio);

  @override
  Future<ProductsModelResponse> getAllProducts() async {
    final logger = Logger();

    try {
      logger.i("getting available products ....");

      final response = await dio.get("${Constants.kBaserUrl}products/all");

      if (response.statusCode == 200) {
        return ProductsModelResponse.fromJson(response.data);
      } else if (response.statusCode != 500) {
        logger.e("Error thrown is ${response.data['message']}");
        throw ServerException(
          message: response.data['message'] ?? "An error occurred, try later",
        );
      } else {
        throw const ServerException(message: "A server error occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<CustomResponse> allocateFeeds(
    int productId,
    int locationId,
    int stock,
  ) async {
    final logger = Logger();

    logger.i("message mcc-allocations/allocate/$productId/$locationId/$stock");

    try {
      final response = await dio.post(
        "${Constants.kBaserUrl}mcc-allocations/allocate/$productId/$locationId/$stock",
      );

      logger.i("server response $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CustomResponse.fromJson(response.data);
      } else if (response.statusCode != 500) {
        logger.e("The error is ${response.data['message']}");
        throw ServerException(
          message: response.data['message'] ?? "An error occurred",
        );
      } else {
        throw const ServerException(message: "A server error occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CustomResponse> transferStock(
    int sourceId,
    int destinationId,
    int productId,
    int stock,
  ) async {
    final logger = Logger();

    try {
      final response = await dio.post(
        "${Constants.kBaserUrl}mcc-allocations/transfer/$sourceId/$destinationId/$productId/$stock",
      );

      logger.i("server response $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CustomResponse.fromJson(response.data);
      } else if (response.statusCode != 500) {
        logger.e("The error is ${response.data['message']}");
        throw ServerException(
          message: response.data['message'] ?? "An error occurred",
        );
      } else {
        throw const ServerException(message: "A server error occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductsModelResponse> getAllFeedAllocations() async {
    final logger = Logger();
    try {
      logger.i("sending allocations request to server");
      final response = await dio.get(
        "${Constants.kBaserUrl}mcc-allocations/all",
      );
      logger.i("response from server $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductsModelResponse.fromJson(response.data);
      } else if (response.statusCode != 500) {
        logger.e("The error is ${response.data['message']}");
        throw ServerException(
          message: response.data['message'] ?? "An error occurred",
        );
      } else {
        throw const ServerException(message: "A server error occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
