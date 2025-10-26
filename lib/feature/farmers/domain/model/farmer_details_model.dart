// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FarmerDetailsModel extends Equatable {
  final String? message;
  final int? statusCode;
  final FarmerDetailsEntityModel? entity;

  const FarmerDetailsModel({this.entity, this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class FarmerDetailsEntityModel extends Equatable {
  final int? id;
  final String? county;
  final int? farmerNo;
  final String? mobileNo;
  final String? createdAt;
  final String? subcounty;
  final String? route;
  final String? pickUpLocation;
  final String? username;
  final String? alternativeMobileNo;
  final String? lastName;
  final String? accountNumber;
  final int? noOfCows;
  final String? memberType;
  final int? routeId;
  final String? deletedFlag;
  final String? paymentFreequency;
  final String? idNumber;
  final String? accountName;
  final String? paymentMode;
  final String? location;
  final String? subLocation;

  const FarmerDetailsEntityModel(
      {this.id,
      this.idNumber,
      this.county,
      this.noOfCows,
      this.route,
      this.pickUpLocation,
      this.username,
      this.accountName,
      this.accountNumber,
      this.alternativeMobileNo,
      this.createdAt,
      this.deletedFlag,
      this.farmerNo,
      this.lastName,
      this.memberType,
      this.mobileNo,
      this.location,
      this.subLocation,
      this.paymentFreequency,
      this.paymentMode,
      this.routeId,
      this.subcounty});

  @override
  List<Object?> get props => [
        id,
        idNumber,
        county,
        noOfCows,
        route,
        pickUpLocation,
        username,
        accountName,
        accountNumber,
        alternativeMobileNo,
        createdAt,
        deletedFlag,
        farmerNo,
        lastName,
        memberType,
        mobileNo,
        paymentFreequency,
        paymentMode,
        routeId,
        subcounty,
        location,
        subLocation
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'county': county,
      'farmerNo': farmerNo,
      'mobileNo': mobileNo,
      'createdAt': createdAt,
      'subcounty': subcounty,
      'route': route,
      'pickUpLocation': pickUpLocation,
      'username': username,
      'alternativeMobileNo': alternativeMobileNo,
      'lastName': lastName,
      'accountNumber': accountNumber,
      'noOfCows': noOfCows,
      'memberType': memberType,
      'routeId': routeId,
      'deletedFlag': deletedFlag,
      'paymentFreequency': paymentFreequency,
      'idNumber': idNumber,
      'accountName': accountName,
      'paymentMode': paymentMode,
      'location': location,
      'subLocation': subLocation,
    };
  }

  factory FarmerDetailsEntityModel.fromMap(Map<String, dynamic> map) {
    return FarmerDetailsEntityModel(
      id: map['id'] != null ? map['id'] as int : null,
      county: map['county'] != null ? map['county'] as String : null,
      farmerNo: map['farmer_no'] != null ? map['farmer_no'] as int : null,
      mobileNo: map['mobile_no'] != null ? map['mobile_no'] as String : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      subcounty: map['subcounty'] != null ? map['subcounty'] as String : null,
      route: map['route'] != null ? map['route'] as String : null,
      pickUpLocation: map['pickUpLocation'] != null ? map['pickUpLocation'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      alternativeMobileNo: map['alternative_mobile_no'] != null ? map['alternative_mobile_no'] as String : null,
      lastName: map['last_name'] != null ? map['last_name'] as String : null,
      accountNumber: map['account_number'] != null ? map['account_number'] as String : null,
      noOfCows: map['no_of_cows'] != null ? map['no_of_cows'] as int : null,
      memberType: map['member_type'] != null ? map['member_type'] as String : null,
      routeId: map['routeId'] != null ? map['routeId'] as int : null,
      deletedFlag: map['deletedFlag'] != null ? map['deletedFlag'] as String : null,
      paymentFreequency: map['paymentFreequency'] != null ? map['paymentFreequency'] as String : null,
      idNumber: map['idNumber'] != null ? map['idNumber'] as String : null,
      accountName: map['accountName'] != null ? map['accountName'] as String : null,
      paymentMode: map['paymentMode'] != null ? map['paymentMode'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      subLocation: map['subLocation'] != null ? map['subLocation'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FarmerDetailsEntityModel.fromJson(String source) => FarmerDetailsEntityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
