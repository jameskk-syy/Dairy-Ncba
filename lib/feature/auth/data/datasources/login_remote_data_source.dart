import 'package:dairytenantapp/feature/auth/domain/models/firstloginotpresponse.dart';
import 'package:dairytenantapp/feature/auth/domain/models/loginResponse.dart';
import 'package:dairytenantapp/feature/auth/domain/models/reset_first_password.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';

abstract class LoginRemoteDataSource {
  Future<AuthLoginResponse> login(String username, String password);

  Future validateOtp(String username, String password) async {}
  Future validateFirstTimeLoginOtp(String username, String password) async {}

  Future resetFirstTimeLoginPassword(String token, String password) async {}
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;
  LoginRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthLoginResponse> login(String username, String password) async {
    final log = Logger();
    try {
      log.e(("Sending login request -------->>"));
      final response = await dio.post(
          '${Constants.kBaserUrl}authentication/login',
          data: {'username': username, 'password': password});
      if (response.statusCode == 200) {
        var resp = AuthLoginResponse.fromJson(response.data);
        log.e("The error thrown is ${response.data}");
        log.e("The error thrown is ${resp.entity?.firstLogin}");
        return resp;
      } else if (response.statusCode != 500) {
        // error response body
        final errorBody = response.data;
        log.e("The error thrown is ${errorBody['message']}");
        throw ServerException(
            message: errorBody['message'] ?? "Try Again Later");
      } else {
        //server error
        throw const ServerException(message: "A Server Error Occurred");
      }
    } on ServerException catch (e) {
      log.e(e.toString());
      throw ServerException(message: e.message);
    } on Exception catch (e) {
      log.e(e.toString());
      throw const ServerException(message: "A server error occurred");
    }
  }
  
  @override
  Future<LoginResponseDto> validateOtp(String username, String otp) async{
    final log = Logger();
    try {
      log.e(("Sending login request -------->>"));
      final response = await dio.post(
          '${Constants.kBaserUrl}authentication/validate/otp',
          data: {'username': username, 'otp': otp});
      if (response.statusCode == 200) {
        var resp = LoginResponseDto.fromJson(response.data['entity']);
        return resp;
      } else if (response.statusCode != 500) {
        // error response body
        final errorBody = response.data;
        log.e("The error thrown is ${errorBody['message']}");
        throw ServerException(
            message: errorBody['message'] ?? "Try Again Later");
      } else {
        //server error
        throw const ServerException(message: "A Server Error Occurred");
      }
    } on ServerException catch (e) {
      log.e(e.toString());
      throw ServerException(message: e.message);
    } on Exception catch (e) {
      log.e(e.toString());
      throw const ServerException(message: "A server error occurred");
    }
  }
  
  @override
  Future <OtpFirstLoginResponse> validateFirstTimeLoginOtp(String username, String otp) async {
     final log = Logger();
    try {
      log.e(("Sending first  login otp request -------->>"));
      final response = await dio.post(
          '${Constants.kBaserUrl}authentication/validate/otp',
          data: {'username': username, 'otp': otp});
      if (response.statusCode == 201) {
        var resp = OtpFirstLoginResponse.fromJson(response.data);
        return resp;
      } else if (response.statusCode != 500) {
        // error response body
        final errorBody = response.data;
        log.e("The error thrown is ${errorBody['message']}");
        throw ServerException(
            message: errorBody['message'] ?? "Try Again Later");
      } else {
        //server error
        throw const ServerException(message: "A Server Error Occurred");
      }
    } on ServerException catch (e) {
      log.e(e.toString());
      throw ServerException(message: e.message);
    } on Exception catch (e) {
      log.e(e.toString());
      throw const ServerException(message: "A server error occurred");
    }
  }
  
  @override
  Future <PasswordChangeResponse>resetFirstTimeLoginPassword(String token, String password) async{
    final log = Logger();
    try {
      log.e(("Sending first  login otp request -------->>"));
      final response = await dio.put(
          '${Constants.kBaserUrl}authentication/reset-password',
          data: {'resetPasswordToken': token, 'password': password});
      if (response.statusCode == 200) {
        var resp = PasswordChangeResponse.fromJson(response.data);
        return resp;
      } else if (response.statusCode != 500) {
        final errorBody = response.data;
        log.e("The error thrown is ${errorBody['message']}");
        throw ServerException(
            message: errorBody['message'] ?? "Try Again Later");
      } else {
        throw const ServerException(message: "A Server Error Occurred");
      }
    } on ServerException catch (e) {
      log.e(e.toString());
      throw ServerException(message: e.message);
    } on Exception catch (e) {
      log.e(e.toString());
      throw const ServerException(message: "A server error occurred");
    }
  }
}
