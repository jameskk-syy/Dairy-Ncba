import 'package:equatable/equatable.dart';

class FarmersResponseModel extends Equatable {
  final String? message;
  final int? statusCode;
  final List<FarmersEntityModel>? entity;

  const FarmersResponseModel({this.message, this.statusCode, this.entity});

  @override
  List<Object?> get props => [message, statusCode, entity];
}

class FarmersEntityModel extends Equatable {
  final String? routeName;
  final int? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? idNumber;
  final int? farmerNo;
  final String? mobileNo;
  final String? alternativeMobileNo;
  final String? memberType;
  final BankDetailsModel? bankDetails;
  final String? address;
  final String? paymentFreequency;
  final String? paymentDate;
  final String? paymentMode;
  final String? createdAt;
  final String? deletedFlag;
  final String? deletedOn;
  final String? location;
  final String? subLocation;
  final String? village;
  final int? countyFk;
  final int? subcountyFk;
  final int? wardFk;
  final int? noOfCows;
  final int? routeFk;
  final String? transportMeans;
  final String? gender;

  const FarmersEntityModel({
    this.paymentMode,
    this.paymentFreequency,
    this.mobileNo,
    this.memberType,
    this.lastName,
    this.farmerNo,
    this.deletedFlag,
    this.createdAt,
    this.alternativeMobileNo,
    this.username,
    this.noOfCows,
    this.idNumber,
    this.id,
    this.routeName,
    this.address,
    this.bankDetails,
    this.countyFk,
    this.deletedOn,
    this.firstName,
    this.gender,
    this.location,
    this.paymentDate,
    this.routeFk,
    this.subcountyFk,
    this.subLocation,
    this.transportMeans,
    this.village,
    this.wardFk,
  });

  @override
  List<Object?> get props => [
    paymentMode,
    paymentFreequency,
   mobileNo,
    memberType,
    lastName,
    farmerNo,
    deletedFlag,
    createdAt,
    alternativeMobileNo,
    username,
    noOfCows,
    idNumber,
    id,
    routeName,
    address,
    bankDetails,
    countyFk,
    deletedOn,
    firstName,
    gender,
    location,
    paymentDate,
    routeFk,
    subcountyFk,
    subLocation,
    transportMeans,
    village,
    wardFk,
  ];
}

class BankDetailsModel extends Equatable {
  final int? id;
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final String? branch;
  final String? otherMeans;
  final String? otherMeansDetails;

  const BankDetailsModel(
      {this.id,
      this.bankName,
      this.accountName,
      this.accountNumber,
      this.branch,
      this.otherMeans,
      this.otherMeansDetails});

  @override
  List<Object?> get props {
    return [
      id,
      bankName,
      accountName,
      accountNumber,
      branch,
      otherMeans,
      otherMeansDetails
    ];
  }
}
