import 'package:dairytenantapp/core/data/dto/farmer_details_dto.dart';
import 'package:dairytenantapp/feature/farmers/domain/model/farmer_details_model.dart';
import '../../domain/model/farmers_response_model.dart';
import '../datasources/local/entity/farmer_entity.dart';

FarmerEntity fromEntityToDomain(FarmersEntityModel farmer) {
  return FarmerEntity(
    routeName: farmer.routeName ?? '',
    address: farmer.address ?? '',
    alternativeMobileNo: farmer.alternativeMobileNo ?? '',
    countyFk: farmer.countyFk ?? 0,
    createdAt: farmer.createdAt ?? '',
    deletedFlag: farmer.deletedFlag ?? '',
    deletedOn: farmer.deletedOn ?? '',
    farmerNo: farmer.farmerNo ?? 0,
    firstName: farmer.firstName ?? '',
    gender: farmer.gender ?? '',
    id: farmer.id ?? 0,
    idNumber: farmer.idNumber ?? '',
    lastName: farmer.lastName ?? '',
    location: farmer.location ?? '',
    memberType: farmer.memberType ?? '',
    mobileNo: farmer.mobileNo ?? '',
    noOfCows: farmer.noOfCows ?? 0,
    paymentDate: farmer.paymentDate ?? '',
    paymentFreequency: farmer.paymentFreequency ?? '',
    paymentMode: farmer.paymentMode ?? '',
    routeFk: farmer.routeFk ?? 0,
    subLocation: farmer.subLocation ?? '',
    subcountyFk: farmer.subcountyFk ?? 0,
    transportMeans: farmer.transportMeans ?? '',
    username: farmer.username ?? '',
    village: farmer.village ?? '',
    wardFk: farmer.wardFk ?? 0,
  );
}

FarmersEntityModel toEntity(FarmerEntity entity) {
  return FarmersEntityModel(
    address: entity.address,
    alternativeMobileNo: entity.alternativeMobileNo,
    countyFk: entity.countyFk,
    createdAt: entity.createdAt,
    deletedFlag: entity.deletedFlag,
    deletedOn: entity.deletedOn,
    farmerNo: entity.farmerNo,
    firstName: entity.firstName,
    gender: entity.gender,
    id: entity.id,
    idNumber: entity.idNumber,
    lastName: entity.lastName,
    location: entity.location,
    memberType: entity.memberType,
    mobileNo: entity.mobileNo,
    noOfCows: entity.noOfCows,
    paymentDate: entity.paymentDate,
    paymentFreequency: entity.paymentFreequency,
    paymentMode: entity.paymentMode,
    routeFk: entity.routeFk,
    subLocation: entity.subLocation,
    subcountyFk: entity.subcountyFk,
    transportMeans: entity.transportMeans,
    username: entity.username,
    village: entity.village,
    wardFk: entity.wardFk,
  );
}

FarmerDetailsEntityModel toFarmerDetailsModel(FarmerEntity entity) {
  return FarmerDetailsEntityModel(
    id: entity.id,
    alternativeMobileNo: entity.alternativeMobileNo,
    createdAt: entity.createdAt,
    deletedFlag: entity.deletedFlag,
    farmerNo: entity.farmerNo,
    idNumber: entity.idNumber,
    lastName: entity.lastName,
    location: entity.location,
    memberType: entity.memberType,
    mobileNo: entity.mobileNo,
    noOfCows: entity.noOfCows,
    paymentFreequency: entity.paymentFreequency,
    paymentMode: entity.paymentMode,
    subLocation: entity.subLocation,
    username: entity.username,
    routeId: entity.routeFk,
  );
}

FarmerDetailsEntityModel getFarmerDetailsModel(FarmerDetailsEntityDto entity) {
  return FarmerDetailsEntityModel(
    id: entity.id,
    alternativeMobileNo: entity.alternativeMobileNo,
    createdAt: entity.createdAt,
    deletedFlag: entity.deletedFlag,
    farmerNo: entity.farmerNo,
    idNumber: entity.idNumber,
    lastName: entity.lastName,
    location: entity.location,
    memberType: entity.memberType,
    mobileNo: entity.mobileNo,
    noOfCows: entity.noOfCows,
    paymentFreequency: entity.paymentFreequency,
    paymentMode: entity.paymentMode,
    subLocation: entity.subLocation,
    username: entity.username,
    routeId: entity.routeId,
  );
}
