import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../../core/data/dto/pickup_location.dart';
import '../../../../core/data/dto/routes_response_dto.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../domain/route_totals_dto.dart';

abstract class MccRemoteSource {
  Future<PickupLocationResponseDto> getPickupLocations();
  Future<RoutesResponseDto> getMccRoutes(int pickuplocationId);
  Future<RouteSummaryResponseDto> getRouteSummary(int routeId, int month, String year);
}

class MccRemoteSourceImpl implements MccRemoteSource {
  final Dio dio;

  MccRemoteSourceImpl(this.dio);

  @override
  Future<PickupLocationResponseDto> getPickupLocations() async {
    final log = Logger();
    try {
      final response =
          await dio.get('${Constants.kBaserUrl}pickuplocations/fetch');
      if (kDebugMode) {
        log.i(response.data);
      }
      return PickupLocationResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RoutesResponseDto> getMccRoutes(int pickuplocationId) async {
    final log = Logger();
    try {
      final response = await dio.get(
          '${Constants.kBaserUrl}pickuplocations/routes',
          queryParameters: {"pickuplocationId": pickuplocationId});
      if (kDebugMode) {
        log.i(response.data);
      }
      return RoutesResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

    @override
  Future<RouteSummaryResponseDto> getRouteSummary(int routeId, int month, String year) async {
    final log = Logger();
    try {
      final response = await dio.get(
          '${Constants.kBaserUrl}collections/route-summary/$routeId/$month/$year');
      if (kDebugMode) {
        log.i(response.data);
      }
      return RouteSummaryResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }
}
