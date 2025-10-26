import 'package:dairytenantapp/core/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: Constants.kFarmersTable)
class FarmerEntity extends Equatable {
  @primaryKey
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String idNumber;
  final int farmerNo;
  final String mobileNo;
  final String alternativeMobileNo;
  final String memberType;

  //BankDetailsModel? bankDetails;
  final String address;
  final String paymentFreequency;
  final String paymentDate;
  final String paymentMode;
  final String createdAt;
  final String deletedFlag;
  final String deletedOn;
  final String location;
  final String subLocation;
  final String village;
  final int countyFk;
  final int subcountyFk;
  final int wardFk;
  final int noOfCows;
  final int routeFk;
  final String transportMeans;
  final String gender;
  final String routeName;

  const FarmerEntity({
    required this.gender,
    required this.transportMeans,
    required this.farmerNo,
    required this.username,
    required this.subLocation,
    required this.location,
    required this.createdAt,
    required this.idNumber,
    required this.mobileNo,
    required this.lastName,
    required this.address,
    required this.memberType,
    required this.paymentFreequency,
    required this.firstName,
    required this.village,
    required this.subcountyFk,
    required this.routeFk,
    required this.paymentDate,
    required this.deletedOn,
    required this.countyFk,
    required this.id,
    required this.noOfCows,
    required this.alternativeMobileNo,
    required this.deletedFlag,
    required this.paymentMode,
    required this.routeName,
    required this.wardFk,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    firstName,
    lastName,
    idNumber,
    farmerNo,
    mobileNo,
    alternativeMobileNo,
    memberType,
    address,
    paymentFreequency,
    paymentDate,
    paymentMode,
    createdAt,
    deletedFlag,
    deletedOn,
    location,
    subLocation,
    village,
    countyFk,
    subcountyFk,
    wardFk,
    noOfCows,
    routeFk,
    transportMeans,
    gender,
    routeName,
  ];
}
