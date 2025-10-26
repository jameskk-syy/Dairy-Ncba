
import '../../../feature/farmers/domain/model/farmers_response_model.dart';

/*class FarmersDto extends FarmersResponseModel {
  FarmersDto({super.message, super.statusCode, super.entity});

  factory FarmersDto.fromJson(Map<String, dynamic> json) {
    return FarmersDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null
          ? (json['entity'] as List)
              .map((i) => FarmersEntityDto.fromJson(i))
              .toList()
          : null,
    );
  }
}

class FarmersEntityDto extends FarmersEntityModel {
  FarmersEntityDto(
      {super.id,
      super.county,
      super.farmerNo,
      super.mobileNo,
      super.createdAt,
      super.subcounty,
      super.route,
      super.pickUpLocation,
      super.username,
      super.alternativeMobileNo,
      super.lastName,
      super.accountNumber,
      super.noOfCows,
      super.memberType,
      super.routeId,
      super.deletedFlag,
      super.paymentFreequency,
      super.idNumber,
      super.accountName,
      super.paymentMode});

  factory FarmersEntityDto.fromJson(Map<String, dynamic> json) {
    return FarmersEntityDto(
      id: json['id'],
      county: json['county'],
      farmerNo: json['farmer_no'],
      mobileNo: json['mobile_no'],
      createdAt: json['created_at'],
      subcounty: json['subcounty'],
      route: json['route'],
      pickUpLocation: json['pickUpLocation'],
      username: json['username'],
      alternativeMobileNo: json['alternative_mobile_no'],
      lastName: json['last_name'],
      accountNumber: json['account_number'],
      noOfCows: json['no_of_cows'],
      memberType: json['member_type'],
      routeId: json['routeId'],
      deletedFlag: json['deleted_flag'],
      paymentFreequency: json['payment_freequency'],
      idNumber: json['id_number'],
      accountName: json['account_name'],
      paymentMode: json['payment_mode'],
    );
  }
}*/

class FarmerResponseDto extends FarmersResponseModel {
  const FarmerResponseDto({super.message, super.statusCode, super.entity});

  factory FarmerResponseDto.fromJson(Map<String, dynamic> json) {
    return FarmerResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null
          ? (json['entity'] as List)
              .map((i) => FarmersResponseEntity.fromJson(i))
              .toList()
          : null,
    );
  }
}

class FarmersResponseEntity extends FarmersEntityModel {
  const FarmersResponseEntity(
      {super.id,
      super.username,
      super.firstName,
      super.lastName,
      super.idNumber,
      super.farmerNo,
      super.mobileNo,
      super.alternativeMobileNo,
      super.memberType,
      super.bankDetails,
      super.routeName,
      super.address,
      super.paymentFreequency,
      super.paymentDate,
      super.paymentMode,
      super.createdAt,
      super.deletedFlag,
      super.deletedOn,
      super.location,
      super.subLocation,
      super.village,
      super.countyFk,
      super.subcountyFk,
      super.wardFk,
      super.noOfCows,
      super.routeFk,
      super.transportMeans,
      super.gender});

  factory FarmersResponseEntity.fromJson(Map<String, dynamic> json) {
    return FarmersResponseEntity(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      idNumber: json['idNumber'],
      farmerNo: json['farmerNo'],
      routeName: json['routeName'],
      mobileNo: json['mobileNo'],
      alternativeMobileNo: json['alternativeMobileNo'],
      memberType: json['memberType'],
      bankDetails: json['bankDetails'] != null
          ? BankDetailsDto.fromJson(json['bankDetails'])
          : null,
      address: json['address'],
      paymentFreequency: json['paymentFreequency'],
      paymentDate: json['paymentDate'],
      paymentMode: json['paymentMode'],
      createdAt: json['createdAt'],
      deletedFlag: json['deletedFlag'],
      deletedOn: json['deletedOn'],
      location: json['location'],
      subLocation: json['subLocation'],
      village: json['village'],
      countyFk: json['county_fk'],
      subcountyFk: json['subcounty_fk'],
      wardFk: json['wardFk'],
      noOfCows: json['noOfCows'],
      routeFk: json['routeFk'],
      transportMeans: json['transportMeans'],
      gender: json['gender'],
    );
  }
}

class BankDetailsDto extends BankDetailsModel {
  const BankDetailsDto(
      {super.id,
      super.bankName,
      super.accountName,
      super.accountNumber,
      super.branch,
      super.otherMeans,
      super.otherMeansDetails});

  factory BankDetailsDto.fromJson(Map<String, dynamic> json) {
    return BankDetailsDto(
      id: json['id'],
      bankName: json['bankName'],
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      branch: json['branch'],
      otherMeans: json['otherMeans'],
      otherMeansDetails: json['otherMeansDetails'],
    );
  }
}
