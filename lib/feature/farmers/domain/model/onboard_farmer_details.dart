
import '../../../../core/data/dto/onboard_farmer_request_dto.dart';

class FarmerOnboardRequestModel extends FarmerOnboardRequestDto2 {

  const FarmerOnboardRequestModel({
    super.address,
    required super.bankDetails,
    super.countyFk,
    super.createdAt,
    super.deletedFlag,
    super.deletedOn,
    super.farmerNo,
    super.firstName,
    super.gender,
    super.id,
    super.memberType,
    super.idNo,
    super.lastName,
    super.location,
    super.mobileNumber,
    super.paymentMode,
    super.routeFk,
    super.subLocation,
    super.subcountyFk,
    required super.nextOfKin,
    super.tier,
    super.wardFk,
    super.username,
    });
}

class BankDetailsModel extends BankDetailsDto2 {

  const BankDetailsModel({
    super.accountName,
    super.accountNumber,
    super.bankName,
    super.branch,
    super.id,
    super.otherMeans,
    super.otherMeansDetails,
  });

}

class NextOfKinModel extends NextOfKin {

  const NextOfKinModel(
      {super.address,
      super.id,
      super.idNo,
      super.name,
      super.relationship,
      super.tel});
}

