import '../../../feature/farmers/domain/model/farmer_details_model.dart';

class FarmerDetailsDto extends FarmerDetailsModel {


  const FarmerDetailsDto({super.message, super.statusCode, super.entity});

  factory FarmerDetailsDto.fromJson(Map<String, dynamic> json) {
    return FarmerDetailsDto(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: json['entity'] != null
          ? FarmerDetailsEntityModel.fromMap(json['entity'])
          : null,
    );
  }
}

class FarmerDetailsEntityDto extends FarmerDetailsEntityModel  {


  const FarmerDetailsEntityDto(
      {
        super.id,
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
        super.location,
        super.subLocation,
        super.paymentMode});

  factory FarmerDetailsEntityDto.fromJson(Map<String, dynamic> json) {
    return FarmerDetailsEntityDto(
        id: json['id'],
        county: json['county'],
        farmerNo: json['farmerNo'],
        mobileNo: json['mobile_no'],
        createdAt: json['created_at'],
        subcounty: json['subcounty'],
        route: json['routeName'],
        pickUpLocation: json['pickUpLocation'],
        username: json['username'],
        alternativeMobileNo: json['alternative_mobile_no'],
        lastName: json['last_name'],
        accountNumber: json['account_number'],
        noOfCows: json['no_of_cows'],
        memberType: json['memberType'],
        routeId: json['routeFk'],
        deletedFlag: json['deleted_flag'],
        paymentFreequency: json['payment_freequency'],
        idNumber: json['idNumber'],
        accountName: json['account_name'],
        paymentMode: json['payment_mode'],
        location: json['location'],
        subLocation: json['subLocation']
    );
  }
}
