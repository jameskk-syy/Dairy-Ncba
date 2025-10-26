import 'package:dairytenantapp/feature/auth/domain/models/firstloginotpresponse.dart';
import 'package:dairytenantapp/feature/auth/domain/models/loginResponse.dart';
import 'package:dairytenantapp/feature/auth/domain/models/reset_first_password.dart';
import 'package:dairytenantapp/feature/auth/domain/models/validateotp.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class LoginRepository {
  Future<Either<Failure, AuthLoginResponse>> login(String username, String password);

   Future<Either<Failure, LoginResponse>> validateOtp(String username, String otp);
   Future<Either<Failure, OtpFirstLoginResponse>> validateFirstTimeLoginOtp(String username, String otp);
   Future<Either<Failure, PasswordChangeResponse>> resetFirstTimeLoginPassword(String token, String password);

}