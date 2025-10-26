import 'package:dairytenantapp/core/data/datasources/local/datasource/core_local_datasource.dart';
import 'package:dairytenantapp/core/errors/failures.dart';
import 'package:dairytenantapp/feature/auth/domain/models/firstloginotpresponse.dart';
import 'package:dairytenantapp/feature/auth/domain/models/loginResponse.dart';
import 'package:dairytenantapp/feature/auth/domain/models/reset_first_password.dart';
import 'package:dairytenantapp/feature/auth/domain/models/validateotp.dart';
import 'package:dairytenantapp/feature/auth/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final NetworkInfo networkInfo;
  final LoginRemoteDataSource remoteDataSource;
  final CoreLocalDataSource localDataSource;

  LoginRepositoryImpl(
    this.networkInfo,
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, AuthLoginResponse>> login(
    String username,
    String password,
  ) async {
    if (await networkInfo.isConnected()) {
      try {
        //login success
        final remoteLogin = await remoteDataSource.login(username, password);
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }
  
  @override
  Future<Either<Failure, LoginResponse>> validateOtp(String username, String otp) async{
   if (await networkInfo.isConnected()) {
      try {
        //login success
        final remoteLogin = await remoteDataSource.validateOtp(username, otp);
        await localDataSource.setIsLoggedIn(true);
        await localDataSource.saveUserData(remoteLogin);
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }
  
  @override
  Future<Either<Failure, OtpFirstLoginResponse>> validateFirstTimeLoginOtp(String username, String otp)  async{
   if (await networkInfo.isConnected()) {
      try {
        //login success
        final remoteLogin = await remoteDataSource.validateFirstTimeLoginOtp(username, otp);
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, PasswordChangeResponse>> resetFirstTimeLoginPassword(String token, String password) async{
    if (await networkInfo.isConnected()) {
      try {
        final remoteLogin = await remoteDataSource.resetFirstTimeLoginPassword(token, password);
        return Right(remoteLogin);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No Internet Connection'));
    }
  }
}
