
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../dto/add_milk_acc_reponse_dto.dart';
import '../dto/total_milk_accumulation_dto.dart';
import '../dto/totals_collections_history_dto.dart';

abstract class MilkAccumulationDataSource {
  Future<AddMilkAccumulationResponseDto> addMilkAccumulation(MilkTotalsAccumulationDto requestBody);
  Future<TotalsCollectionHistoryDto> getMilkAccumulationHistory(int collectorId);
  Future<TotalsCollectionHistoryDto> getMilkAccumulationHistoryByDate(int collectorId, String date);
}

class MilkAccumulationDataSourceImpl implements MilkAccumulationDataSource {
  final Dio dio;
  MilkAccumulationDataSourceImpl(this.dio);

  @override
  Future<AddMilkAccumulationResponseDto> addMilkAccumulation(MilkTotalsAccumulationDto requestBody) async {
    final log = Logger();
    try {
      final response = await dio.post(
          '${Constants.kBaserUrl}accumulation/add',
          data: requestBody.toJson()

      );
      log.i(response.data);
      log.i(requestBody.toJson());
      return AddMilkAccumulationResponseDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<TotalsCollectionHistoryDto> getMilkAccumulationHistory(int collectorId) async {
    final log = Logger();
    try {
      final response = await dio.get(
          '${Constants.kBaserUrl}accumulation/by-accumulator/$collectorId',
      );
      log.i(response.data.length);
      return TotalsCollectionHistoryDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<TotalsCollectionHistoryDto> getMilkAccumulationHistoryByDate(int collectorId, String date) async {
    final log = Logger();
    log.i('collectorId: $collectorId, date: $date');
    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}accumulation/$collectorId/$date',
      );
      log.i(response.data);
      log.i('collectorId: $collectorId, date: $date');
      return TotalsCollectionHistoryDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }
}