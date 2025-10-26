import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../../../farmers/domain/model/deliveries_dto.dart';

abstract class FOHomeRemoteSource {
  Future<DeliveryResponseDto> getDeliveries(
      int farmerNo, String from, String to);
  Future<http.Response> getStatement(int farmerNo, String from, String to);
  Future<http.Response> getAllocationHistory(int month, String year);
  Future<http.Response> getRouteReport(int routeId, int month, String year);
}

class FOHomeRemoteSourceImpl implements FOHomeRemoteSource {
  final Dio dio;

  FOHomeRemoteSourceImpl(this.dio);

  @override
  Future<DeliveryResponseDto> getDeliveries(
      int farmerNo, String from, String to) async {
    final Logger logger = Logger();

    try {
      logger.i("getting farmer deliveries");

      final response = await dio.get(
          "${Constants.kBaserUrl}collections/farmer/deliveries/$farmerNo/$from/$to");
      logger.i("response from server $response");

      if (response.statusCode == 200) {
        return DeliveryResponseDto.fromJson(response.data);
      } else if (response.statusCode != 500) {
        final String error = response.data['message'];
        logger.e("error thrown is $error");
        throw ServerException(
            message: response.data['message'] ?? "Try again later");
      } else {
        throw const ServerException(message: "A server error occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<http.Response> getStatement(
      int farmerNo, String from, String to) async {
    final Logger logger = Logger();

    try {
      logger.i("getting statement ");
      final response = await http.get(Uri.parse(
          '${Constants.kBaserUrl}reports/farmer/statement?farmerNo=$farmerNo&from=$from&to=$to'));

      if (response.statusCode == 200) {
        logger.i("statement success");
        return response;
      } else if (response.statusCode != 500) {
        logger.e("error getting file: ${jsonDecode(response.body)['message']}");
        throw ServerException(
            message:
                jsonDecode(response.body)['message'] ?? "An error occurred");
      } else {
        throw const ServerException(message: "A server error occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<http.Response> getAllocationHistory(int month, String year) async {
    final Logger logger = Logger();

    try {
      logger.i("retrieving allocation history for $month/$year");
      final response = await http.get(Uri.parse(
          '${Constants.kBaserUrl}excel/reports/allocations/history/$month/$year'));

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode != 500) {
        logger
            .e("error getting report: ${jsonDecode(response.body)["message"]}");

        throw ServerException(
            message:
                jsonDecode(response.body)["message"] ?? "An error occurred");
      } else {
        throw const ServerException(message: "A server occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<http.Response> getRouteReport(
      int routeId, int month, String year) async {
    final Logger logger = Logger();

    try {
      logger.i("retrieving route delivery history for $month/$year");
      final response = await http.get(Uri.parse(
          '${Constants.kBaserUrl}excel/reports/route/summary/$routeId/$month/$year'));

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode != 500) {
        logger
            .e("error getting report: ${jsonDecode(response.body)["message"]}");

        throw ServerException(
            message:
                jsonDecode(response.body)["message"] ?? "An error occurred");
      } else {
        throw const ServerException(message: "A server occurred");
      }
    } on ServerException catch (e) {
      logger.e(e.toString());
      throw ServerException(message: e.message);
    }
  }
}
