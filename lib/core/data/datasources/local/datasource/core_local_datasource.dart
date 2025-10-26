import 'dart:convert';

import 'package:dairytenantapp/core/data/datasources/local/datasource/local/entity/routes_entity.dart';
import 'package:dairytenantapp/core/data/dto/login_response_dto.dart';
import 'package:dairytenantapp/core/errors/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/app_database.dart';

abstract class CoreLocalDataSource {
  //User Data stored on shared preferences
  Future<void> saveUserData(LoginResponseDto user);
  Future<void> setIsLoggedIn(bool isLoggedIn);
  Future<LoginResponseDto> getUserData();
  Future<bool> getIsLoggedIn();

  //Routes
  Future<void> insertRoutes(List<RoutesEntity> routesEntity);
  Future<List<RoutesEntity>> getAllRoutes();
  Future<void> deleteAllRoutes();
}

class AppLocalDataSourceImpl implements CoreLocalDataSource {
  final SharedPreferences sharedPreferences;
  final BahatisDatabase database;

  AppLocalDataSourceImpl(this.sharedPreferences, this.database);

  @override
  Future<void> saveUserData(LoginResponseDto user) async {
    try {
      final userData = json.encode(user.toJson());
      await sharedPreferences.setString('userData', userData);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    try {
      await sharedPreferences.setBool('isLoggedIn', isLoggedIn);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<bool> getIsLoggedIn() async {
    try {
      return sharedPreferences.getBool('isLoggedIn') ?? false;
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<LoginResponseDto> getUserData() {
    try {
      final userData = sharedPreferences.getString('userData');
      if (userData != null) {
        final user = LoginResponseDto.fromJson(json.decode(userData));
        return Future.value(user);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> deleteAllRoutes() async {
    try {
      await database.routesDao.deleteAllRoutes();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<List<RoutesEntity>> getAllRoutes() async {
    try {
      return await database.routesDao.getAllRoutes();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> insertRoutes(List<RoutesEntity> routesEntity) async {
    try {
      await database.routesDao.insertRoutes(routesEntity);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }
}
