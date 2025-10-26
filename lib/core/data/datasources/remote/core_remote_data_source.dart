import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../errors/exceptions.dart';
import '../../../utils/constants.dart';
import '../../dto/can_response_dto.dart';
import '../../dto/collector_routes_dto.dart';
import '../../dto/collectors_response_dto.dart';
import '../../dto/counties_dto.dart';
import '../../dto/pickup_location.dart';
import '../../dto/routes_response_dto.dart';
import '../../dto/sub_counties_dto.dart';

abstract class CoreRemoteDataSource {
  Future<CanResponseDto> getCanList();
  Future<CountiesResponseDto> getCounties();
  Future<SubCountiesResponseDto> getSubCounties();
  Future<PickupLocationResponseDto> getCollectorPickupLocations(
    int collectorId,
  );
  Future<RoutesResponseDto> getRoutes();
  Future<CollectorRoutesResponseDto> getCollectorRoutes(int collectorId);
  Future<MilkCollectorsDto> getMilkCollectors();
}

class CanRemoteDataSourceImpl implements CoreRemoteDataSource {
  final Dio dio;
  CanRemoteDataSourceImpl(this.dio);

  @override
  Future<CanResponseDto> getCanList() async {
    final log = Logger();
    try {
      final response = await dio.get('${Constants.kBaserUrl}can/fetch');
      if (kDebugMode) {
        log.e(response.data);
      }
      return CanResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CountiesResponseDto> getCounties() async {
    final log = Logger();
    try {
      final response = await dio.get('${Constants.kBaserUrl}county/get');
      if (kDebugMode) {
        log.e(response.data);
      }
      return CountiesResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SubCountiesResponseDto> getSubCounties() async {
    final log = Logger();
    try {
      final response = await dio.get('${Constants.kBaserUrl}Subcounty/fetch');
      if (kDebugMode) {
        log.e(response.data);
      }
      return SubCountiesResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PickupLocationResponseDto> getCollectorPickupLocations(
    int collectorId,
  ) async {
    final log = Logger();
    try {
      String url = "";
      print("collectorId $collectorId");
      if (userRole() == "TRANSPORTER") {
        url = "pickuplocations/transporter/$collectorId";
      } else {
        url = "pickuplocations/collector/$collectorId";
      }

      final response = await dio.get('${Constants.kBaserUrl}$url');
      if (kDebugMode) {
        log.e(response.data);
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
  Future<RoutesResponseDto> getRoutes() async {
    final log = Logger();
    try {
      final response = await dio.get('${Constants.kBaserUrl}routes/fetch');
      if (kDebugMode) {
        log.e(response.data);
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
  Future<CollectorRoutesResponseDto> getCollectorRoutes(int collectorId) async {
    final log = Logger();
    try {
      print("user id $collectorId");
      print("user role ${userRole()}");
      String url = "";
      if (userRole() == "MILK_COLLECTOR") {
        url = "routes/collector/$collectorId";
      } else {
        url = "transporter/get/$collectorId";
      }

      final response = await dio.get('${Constants.kBaserUrl}$url');
      if (kDebugMode) {
        log.i(response.data);
      }
      return CollectorRoutesResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MilkCollectorsDto> getMilkCollectors() async {
    final log = Logger();
    try {
      const roleName = 'MILK_COLLECTOR';
      final response = await dio.get(
        'http://52.15.152.26:9700/admin/api/v1/users/users-by-role-name?roleName=$roleName',
      );
      if (kDebugMode) {
        log.e(response.data);
      }
      return MilkCollectorsDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }
}
