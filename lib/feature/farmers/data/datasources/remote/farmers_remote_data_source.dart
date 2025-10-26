import 'package:dairytenantapp/core/data/dto/farmers_response_dto.dart';
import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../../../core/data/dto/farmer_details_dto.dart';
import '../../../../../core/data/dto/onboard_farmer_request_dto.dart';
import '../../../../../core/data/dto/onboard_farmer_response_dto.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../collections/domain/model/custom_resp_model.dart';

abstract class FarmersRemoteDataSource {
  Future<FarmerResponseDto> getFarmers(int collectorId);
  Future<FarmerResponseDto> getRouteFarmers(int routeId);
  Future<FarmerResponseDto> getMccFarmers(int mccId);
  Future<FarmerDetailsDto> getFarmerDetails(
    int farmerNumber,
    /*int collectorId*/
  );
  //Future<Either<Failure, Unit>> addFarmer(Map<String, dynamic> farmer);
  Future<OnBoardFarmerResponseDto> addFarmer(FarmerOnboardRequestDto2 farmer);
  Future<CustomResponse> updateRoute(int farmerNo, int routeId);
}

class FarmersRemoteDataSourceImpl implements FarmersRemoteDataSource {
  final Dio dio;

  FarmersRemoteDataSourceImpl(this.dio);

  @override
  Future<FarmerResponseDto> getFarmers(int collectorId) async {
    final log = Logger();
    try {
      String url = "";
      if (userRole() == "MILK_COLLECTOR") {
        url = "farmer/farmers/collector/$collectorId";
      } else {
        url = "farmer/farmers/transporter/$collectorId";
      }

      final response = await dio.get('${Constants.kBaserUrl}$url');
      return FarmerResponseDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<FarmerResponseDto> getRouteFarmers(int routeId) async {
    final log = Logger();
    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}farmer/route/$routeId',
      );
      log.i("farmer ${response.data['entity'][0]}");
      return FarmerResponseDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<FarmerResponseDto> getMccFarmers(int mccId) async {
    final log = Logger();
    try {
      final response = await dio.get('${Constants.kBaserUrl}farmer/mcc/$mccId');
      log.i("farmer ${response.data['entity'][0]}");
      return FarmerResponseDto.fromJson(response.data);
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<CustomResponse> updateRoute(int farmerNo, int routeId) async {
    final log = Logger();
    try {
      log.i("farmer information $farmerNo and routeid $routeId");
      final response = await dio.put(
        '${Constants.kBaserUrl}farmer/update/route/$farmerNo/$routeId',
      );

      if (response.statusCode == 200) {
        return CustomResponse.fromJson(response.data);
      } else {
        throw const ServerException(message: "Failed to update farmer route");
      }
    } catch (exception) {
      if (kDebugMode) {
        log.e(exception.toString());
      }
      throw ServerException(message: exception.toString());
    }
  }

  @override
  Future<FarmerDetailsDto> getFarmerDetails(
    int farmerNumber,
    /*int collectorId*/
  ) async {
    final log = Logger();
    try {
      final response = await dio.get(
        '${Constants.kBaserUrl}farmer/membernumber',
        queryParameters: {
          'farmer_number': farmerNumber,
          //'collectorId': collectorId
        },
      );
      /*if (response.statusCode == 200) {
        log.i(response.data);
        return FarmerDetailsDto.fromJson(response.data);
      } else {
        throw ServerException(message: response.statusMessage!);
      }*/

      //log.i(response.statusCode);

      log.i(response.data);
      return FarmerDetailsDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OnBoardFarmerResponseDto> addFarmer(
    FarmerOnboardRequestDto2 farmer,
  ) async {
    final log = Logger();
    try {
      final response = await dio.post(
        '${Constants.kBaserUrl}farmer/add',
        data: farmer.toJson(),
      );
      if (kDebugMode) {
        print(response);
      }
      return OnBoardFarmerResponseDto.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        log.e(e.toString());
      }
      throw ServerException(message: e.toString());
    }
  }
}
