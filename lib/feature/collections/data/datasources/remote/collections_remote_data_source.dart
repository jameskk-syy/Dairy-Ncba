import 'package:dairytenantapp/core/data/dto/collection_totals_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../../../core/data/dto/add_collection_dto.dart';
import '../../../../../core/data/dto/collection_history_dto.dart';
import '../../../../../core/data/dto/collection_response.dart';
import '../../../../../core/data/dto/monthly_totals_dto.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/model/custom_resp_model.dart';
import '../local/entity/collections_entity.dart';

abstract class CollectionsRemoteDataSource {
  Future<CollectionHistoryDto> getCollectionHistory(int collectorId);

  Future<CollectionHistoryDto> getCollectionsByDate(
    int collectorId,
    String date,
  );

  Future<CollectionTotals> getCollectorsDailySupply(
    int collectorId,
    int year,
    int month,
  );

  Future<CollectionTotals> getCollectorsDailyTotals(
    int collectorId,
    int year,
    int month,
  );

  Future<MonthlyTotals> getMonthlyTotals(int month, int collectorId);

  Future<CollectionHistoryDto> getFarmerCollectionsByDateRange(
    int collectorId,
    String farmerNo,
    String startDate,
    String endDate,
    String session,
  );

  Future<CollectionResponse> addCollection(AddCollectionDto collection);

  Future<CustomResponse> returnDelivery(int collectionId);

  Future<CollectionResponse> syncCollection(CollectionsEntity collection);
  //Future<CollectionHistoryDto> getDayCollection(int collectorId, String date);
}

class CollectionsRemoteDataSourceImpl implements CollectionsRemoteDataSource {
  final Dio dio;

  CollectionsRemoteDataSourceImpl(this.dio);

  @override
  Future<CollectionHistoryDto> getCollectionHistory(int collectorId) async {
    final log = Logger();
    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}collections/per/collector',
        queryParameters: {'collectorId': collectorId},
      );
      if (kDebugMode) {
        log.i(response.data);
      }
      return CollectionHistoryDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<CustomResponse> returnDelivery(int collectionId) async {
    final log = Logger();
    try {
      final response = await dio.post(
        '${Constants.kBaserUrl}collections/return/$collectionId',
      );
      if (kDebugMode) {
        log.i(response.data);
      }

      if (response.statusCode != 200) {
        throw const ServerException(message: "try again later");
      } else {
        return CustomResponse.fromJson(response.data);
      }
    } on ServerException catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.message);
    }
  }

  @override
  Future<CollectionTotals> getCollectorsDailyTotals(
    int collectorId,
    int year,
    int month,
  ) async {
    final logger = Logger();

    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}collections/collections/daily/collector',
        queryParameters: {
          'collectorId': collectorId,
          'year': year,
          'month': month,
        },
      );
      if (kDebugMode) {
        logger.i(response.data);
      }
      return CollectionTotals.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        logger.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MonthlyTotals> getMonthlyTotals(int month, int collectorId) async {
    final logger = Logger();
    logger.i("values are $collectorId, $month");

    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}accumulation/monthly/collector/totals',
        queryParameters: {'collectorId': collectorId, 'month': month},
      );
      if (kDebugMode) {
        logger.i(response.data);
        logger.i("info is $collectorId, $month");
      }
      return MonthlyTotals.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        logger.d(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CollectionTotals> getCollectorsDailySupply(
    int collectorId,
    int year,
    int month,
  ) async {
    final logger = Logger();

    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}accumulation/daily/supply/collector',
        queryParameters: {
          'year': year,
          'month': month,
          'collectorId': collectorId,
        },
      );
      if (kDebugMode) {
        logger.d(response.data);
      }
      return CollectionTotals.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        logger.i(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CollectionResponse> addCollection(AddCollectionDto collection) async {
    final log = Logger();
    String? errorMessage;
    try {
      final response = await dio.post(
        '${Constants.kBaserUrl}collections/add',
        data: collection.toJson(),
      );

      if (CollectionResponse.fromJson(response.data).statusCode == 201) {
        log.i(response.data);
        final result = CollectionResponse.fromJson(response.data);
        errorMessage = result.message;
        // throw ServerException(message: message);
        return CollectionResponse.fromJson(response.data);
      } else if (CollectionResponse.fromJson(response.data).statusCode == 406) {
        log.i(response.data);
        log.i(collection.toJson());
        final result = CollectionResponse.fromJson(response.data);
        errorMessage = result.message;
        throw ServerException(message: errorMessage);
        // return CollectionResponse.fromJson(response.data);
      } else {
        log.i(response.data);
        log.i(collection.toJson());
        final message = CollectionResponse.fromJson(response.data).message;
        throw ServerException(message: message);
        // return CollectionResponse.fromJson(response.data);
      }
    } catch (exception) {
      if (kDebugMode) {
        if (exception is ServerException) {
          errorMessage = exception.message;
          log.e(exception.message);
        } else {
          log.e(exception.toString());
        }
      }
      throw ServerException(message: errorMessage ?? 'An error occurred');
    }
  }

  @override
  Future<CollectionHistoryDto> getCollectionsByDate(
    int collectorId,
    String date,
  ) async {
    final log = Logger();
    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}collections/collector/date',
        queryParameters: {'collectorId': collectorId, 'date': date},
      );

      log.i("received data $response");
      if (kDebugMode) {
        // log.i(response.data);
        log.i('collectorId: $collectorId, date: $date');
      }
      return CollectionHistoryDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<CollectionHistoryDto> getFarmerCollectionsByDateRange(
    int collectorId,
    String farmerNo,
    String startDate,
    String endDate,
    String session,
  ) async {
    final log = Logger();
    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}collections/filtered-collections/date',
        queryParameters: {
          'collectorId': collectorId,
          'farmerNo': farmerNo,
          'from': startDate,
          'to': endDate,
          'session': session,
        },
      );

      if (kDebugMode) {
        log.i(response.data);
      }
      return CollectionHistoryDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<CollectionResponse> syncCollection(
    CollectionsEntity collection,
  ) async {
    final log = Logger();
    String? errorMessage;
    try {
      final response = await dio.post(
        '${Constants.kBaserUrl}collections/add',
        data: collection.toJson(),
      );

      if (CollectionResponse.fromJson(response.data).statusCode == 201) {
        log.i(response.data);
        log.i(collection.toJson());
        final message = CollectionResponse.fromJson(response.data).message;
        errorMessage = message;
        // throw ServerException(message: message);
        return CollectionResponse.fromJson(response.data);
      } else if (CollectionResponse.fromJson(response.data).statusCode == 406) {
        log.i(response.data);
        log.i(collection.toJson());
        return CollectionResponse.fromJson(response.data);
      } else {
        log.i(response.data);
        log.i(collection.toJson());
        if (CollectionResponse.fromJson(response.data).statusCode == 400) {
          throw ServerException(
            message: CollectionResponse.fromJson(response.data).message,
          );
        } else {
          return CollectionResponse.fromJson(response.data);
        }
      }
    } catch (exception) {
      if (kDebugMode) {
        if (exception is ServerException) {
          errorMessage = exception.message;
          log.e(exception.message);
        } else {
          log.e(exception.toString());
        }
      }
      throw ServerException(message: errorMessage ?? 'An error occurred');
    }
  }
}
