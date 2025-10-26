import 'dart:convert';

import 'package:dairytenantapp/core/data/dto/login_response_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/injector_container.dart';

LoginResponseDto getUserData() {
  LoginResponseDto user = LoginResponseDto();
  final localStorage = sl<SharedPreferences>();
  final userData = localStorage.getString("userData");

  if (userData != null) {
    user = LoginResponseDto.fromJson(jsonDecode(userData));
  }
  return user;
}

int getLocationId() {
  final localStorage = sl<SharedPreferences>();
  final locationId = localStorage.getInt("locationId");
  return locationId!;
}

String userRole() {
  final user = getUserData();
  final roles = user.roles!.map((role) => role.name).toList();
  final role = roles[0];
  return role!;
}

int getRouteId() {
  final localStorage = sl<SharedPreferences>();
  final routeId = localStorage.getInt("routeId");
  return routeId!;
}
