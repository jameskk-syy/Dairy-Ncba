import 'package:dairytenantapp/core/errors/exceptions.dart';
import 'package:dairytenantapp/core/utils/constants.dart';
import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dairytenantapp/feature/collections/domain/model/custom_resp_model.dart';
import 'package:dairytenantapp/feature/totals/domain/model/product_category.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../domain/model/feed_request_dto.dart';
import '../../domain/model/feeds_requests_model.dart';
import '../../domain/model/products_model.dart';

abstract class FeedsRequestSource {
  Future<ProductCategoryResponse> getAllCategories();
  Future<ProductsModelResponse> getAllProducts(int locationId);
  Future<CustomResponse> addFeedsRequest(FeedRequestDto feedRequestDto);
  Future<CustomResponse> confirmFeedsRequest(int requestId, String status);

  Future<AllFeedsRequestModelResponse> getAllFeedsRequests(
    int locationId,
    int month,
    String year,
  );
}

class FeedsRequestImpl implements FeedsRequestSource {
  final Dio dio;
  const FeedsRequestImpl(this.dio);

  @override
  Future<ProductCategoryResponse> getAllCategories() async {
    final logger = Logger();

    try {
      logger.i("getting available product categories ....");

      final response = await dio.get(
        "${Constants.kBaserUrl}product-categories/find-all-categories",
      );

      if (response.statusCode == 200) {
        var mapped = ProductCategoryResponse.fromJson(response.data);
        return mapped;
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
  Future<ProductsModelResponse> getAllProducts(int locationId) async {
    final logger = Logger();

    try {
      logger.i("getting available products ....");

      final response = await dio.get(
        "${Constants.kBaserUrl}mcc-allocations/get/$locationId",
      );

      if (response.statusCode == 200) {
        return ProductsModelResponse.fromJson(response.data);
      } else if (response.statusCode != 500) {
        logger.e("Error thrown is ${response.data['message']}");
        return ProductsModelResponse.fromJson(response.data);
        // throw ServerException(
        //     message:
        //         response.data['message'] ?? "An error occurred, try later");
      } else {
        throw const ServerException(message: "A server error occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<CustomResponse> addFeedsRequest(FeedRequestDto feedRequestDto) async {
    final logger = Logger();

    try {
      final response = await dio.post(
        "${Constants.kBaserUrl}farmer/allocations/add",
        data: feedRequestDto.toJson(),
      );

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
  Future<CustomResponse> confirmFeedsRequest(
    int requestId,
    String status,
  ) async {
    final logger = Logger();

    try {
      final response = await dio.put(
        "${Constants.kBaserUrl}farmer/allocations/verify",
        queryParameters: {"id": requestId, "status": status},
      );
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
  Future<AllFeedsRequestModelResponse> getAllFeedsRequests(
    int locationId,
    int month,
    String year,
  ) async {
    final logger = Logger();

    try {
      String url = "";

      if (userRole() == "TRANSPORTER") {
        url =
            "farmer/allocations/get/route/${getRouteId()}/$month/${int.parse(year)}";
      } else {
        url = "farmer/allocations/get/$locationId/$month/${int.parse(year)}";
      }

      final response = await dio.get("${Constants.kBaserUrl}$url");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AllFeedsRequestModelResponse.fromJson(response.data);
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
