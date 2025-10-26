import 'package:equatable/equatable.dart';

/*class FarmerOnboardRequestDto extends Equatable {
  String? address;
  String? alternativeMobileNo;
  BankDetails bankDetails;
  int? countyFk;
  String? createdAt;
  String? deletedFlag;
  String? deletedOn;
  int? farmerNo;
  String? firstName;
  String? gender;
  int? id;
  String? idNumber;
  String? lastName;
  String? location;
  String? memberType;
  String? mobileNo;
  int? noOfCows;
  int? paymentDate;
  String? paymentFreequency;
  String? paymentMode;
  int? routeFk;
  String? subLocation;
  int? subcountyFk;
  String? transportMeans;
  String? username;
  String? village;
  int? wardFk;

  FarmerOnboardRequestDto(
      {this.address,
      this.alternativeMobileNo,
       required this.bankDetails,
      this.countyFk,
      this.createdAt,
      this.deletedFlag,
      this.deletedOn,
      this.farmerNo,
      this.firstName,
      this.gender,
      this.id,
      this.idNumber,
      this.lastName,
      this.location,
      this.memberType,
      this.mobileNo,
      this.noOfCows,
      this.paymentDate,
      this.paymentFreequency,
      this.paymentMode,
      this.routeFk,
      this.subLocation,
      this.subcountyFk,
      this.transportMeans,
      this.username,
      this.village,
      this.wardFk});

  factory FarmerOnboardRequestDto.fromJson(Map<String, dynamic> json) {
    return FarmerOnboardRequestDto(
      address: json['address'],
      alternativeMobileNo: json['alternativeMobileNo'],
      bankDetails: BankDetails.fromJson(json['bankDetails']),
      countyFk: json['county_fk'],
      createdAt: json['createdAt'],
      deletedFlag: json['deletedFlag'],
      deletedOn: json['deletedOn'],
      farmerNo: json['farmerNo'],
      firstName: json['firstName'],
      gender: json['gender'],
      id: json['id'],
      idNumber: json['idNumber'],
      lastName: json['lastName'],
      location: json['location'],
      memberType: json['memberType'],
      mobileNo: json['mobileNo'],
      noOfCows: json['noOfCows'],
      paymentDate: json['paymentDate'],
      paymentFreequency: json['paymentFreequency'],
      paymentMode: json['paymentMode'],
      routeFk: json['routeFk'],
      subLocation: json['subLocation'],
      subcountyFk: json['subcounty_fk'],
      transportMeans: json['transportMeans'],
      username: json['username'],
      village: json['village'],
      wardFk: json['wardFk'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['alternativeMobileNo'] = alternativeMobileNo;
    if (bankDetails != null) {
      data['bankDetails'] = bankDetails!.toJson();
    }
    data['county_fk'] = countyFk;
    data['createdAt'] = createdAt;
    data['deletedFlag'] = deletedFlag;
    data['deletedOn'] = deletedOn;
    data['farmerNo'] = farmerNo;
    data['firstName'] = firstName;
    data['gender'] = gender;
    data['id'] = id;
    data['idNumber'] = idNumber;
    data['lastName'] = lastName;
    data['location'] = location;
    data['memberType'] = memberType;
    data['mobileNo'] = mobileNo;
    data['noOfCows'] = noOfCows;
    data['paymentDate'] = paymentDate;
    data['paymentFreequency'] = paymentFreequency;
    data['paymentMode'] = paymentMode;
    data['routeFk'] = routeFk;
    data['subLocation'] = subLocation;
    data['subcounty_fk'] = subcountyFk;
    data['transportMeans'] = transportMeans;
    data['username'] = username;
    data['village'] = village;
    data['wardFk'] = wardFk;
    return data;
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}

class BankDetails extends Equatable {
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? branch;
  int? id;
  String? otherMeans;
  String? otherMeansDetails;

  BankDetails(
      {this.accountName,
      this.accountNumber,
      this.bankName,
      this.branch,
      this.id,
      this.otherMeans,
      this.otherMeansDetails});

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      branch: json['branch'],
      id: json['id'],
      otherMeans: json['otherMeans'],
      otherMeansDetails: json['otherMeansDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountName'] = accountName;
    data['accountNumber'] = accountNumber;
    data['bankName'] = bankName;
    data['branch'] = branch;
    data['id'] = id;
    data['otherMeans'] = otherMeans;
    data['otherMeansDetails'] = otherMeansDetails;
    return data;
  }

  @override
  List<Object?> get props => [
        accountName,
        accountNumber,
        bankName,
        branch,
        id,
        otherMeans,
        otherMeansDetails
      ];
}*/

class FarmerOnboardRequestDto2 extends Equatable {
  final String? address;
  final BankDetailsDto2 bankDetails;
  final String? mobileNumber;
  final int? countyFk;
  final String? createdAt;
  final String? deletedFlag;
  final String? deletedOn;
  final int? farmerNo;
  final String? firstName;
  final String? gender;
  final int? id;
  final String? idNo;
  final String? lastName;
  final String? location;
  final NextOfKin nextOfKin;
  final String? paymentMode;
  final int? routeFk;
  final String? subLocation;
  final int? subcountyFk;
  final String? tier;
  final String? username;
  final int? wardFk;
  final String? memberType;

  const FarmerOnboardRequestDto2(
      {this.address,
      required this.bankDetails,
      this.mobileNumber,
      this.countyFk,
      this.createdAt,
      this.deletedFlag,
      this.deletedOn,
      this.farmerNo,
      this.firstName,
      this.gender,
      this.id,
      this.idNo,
      this.lastName,
      this.location,
      required this.nextOfKin,
      this.paymentMode,
      this.routeFk,
      this.subLocation,
      this.subcountyFk,
      this.tier,
      this.username,
        this.memberType,
      this.wardFk});

  factory FarmerOnboardRequestDto2.fromJson(Map<String, dynamic> json) {
    return FarmerOnboardRequestDto2(
      address: json['address'],
      bankDetails: BankDetailsDto2.fromJson(json['bankDetails']),
      mobileNumber: json['mobileNo'],
      countyFk: json['county_fk'],
      createdAt: json['createdAt'],
      deletedFlag: json['deletedFlag'],
      deletedOn: json['deletedOn'],
      farmerNo: json['farmerNo'],
      firstName: json['firstName'],
      gender: json['gender'],
      id: json['id'],
      memberType: json['memberType'],
      idNo: json['idNumber'],
      lastName: json['lastName'],
      location: json['location'],
      nextOfKin: NextOfKin.fromJson(json['nextOfKin']),
      paymentMode: json['paymentMode'],
      routeFk: json['routeFk'],
      subLocation: json['subLocation'],
      subcountyFk: json['subcounty_fk'],
      tier: json['tier'],
      username: json['username'],
      wardFk: json['wardFk'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['bankDetails'] = bankDetails.toJson();
    data['mobileNo'] = mobileNumber;
    data['county_fk'] = countyFk;
    data['createdAt'] = createdAt;
    data['deletedFlag'] = deletedFlag;
    data['deletedOn'] = deletedOn;
    data['farmerNo'] = farmerNo;
    data['firstName'] = firstName;
    data['gender'] = gender;
    data['id'] = id;
    data['idNumber'] = idNo;
    data['lastName'] = lastName;
    data['location'] = location;
     data['nextOfKin'] = nextOfKin.toJson();
    data['paymentMode'] = paymentMode;
    data['routeFk'] = routeFk;
    data['subLocation'] = subLocation;
    data['subcounty_fk'] = subcountyFk;
    data['tier'] = tier;
    data['username'] = username;
    data['wardFk'] = wardFk;
    data['memberType'] = memberType;
    return data;
  }

  @override
  List<Object?> get props => [
        address,
        bankDetails,
        mobileNumber,
        countyFk,
        createdAt,
        deletedFlag,
        deletedOn,
        farmerNo,
        firstName,
        gender,
        id,
        idNo,
        lastName,
        location,
        nextOfKin,
        paymentMode,
        routeFk,
        subLocation,
        subcountyFk,
        tier,
        username,
        wardFk,
        memberType
      ];
}

class BankDetailsDto2 extends Equatable {
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? branch;
  final int? id;
  final String? otherMeans;
  final String? otherMeansDetails;

  const BankDetailsDto2(
      {this.accountName,
      this.accountNumber,
      this.bankName,
      this.branch,
      this.id,
      this.otherMeans,
      this.otherMeansDetails});

  factory BankDetailsDto2.fromJson(Map<String, dynamic> json) {
    return BankDetailsDto2(
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      branch: json['branch'],
      id: json['id'],
      otherMeans: json['otherMeans'],
      otherMeansDetails: json['otherMeansDetails'],
    );
    /*accountName = json['accountName'];
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    branch = json['branch'];
    id = json['id'];
    otherMeans = json['otherMeans'];
    otherMeansDetails = json['otherMeansDetails'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountName'] = accountName;
    data['accountNumber'] = accountNumber;
    data['bankName'] = bankName;
    data['branch'] = branch;
    data['id'] = id;
    data['otherMeans'] = otherMeans;
    data['otherMeansDetails'] = otherMeansDetails;
    return data;
  }

  @override
  List<Object?> get props => [
        accountName,
        accountNumber,
        bankName,
        branch,
        id,
        otherMeans,
        otherMeansDetails,
      ];
}

class NextOfKin extends Equatable {
  final String? address;
  final int? id;
  final String? idNo;
  final String? name;
  final String? relationship;
  final String? tel;

  const NextOfKin(
      {this.address,
      this.id,
      this.idNo,
      this.name,
      this.relationship,
      this.tel});

  factory NextOfKin.fromJson(Map<String, dynamic> json) {
    return NextOfKin(
      address: json['address'],
      id: json['id'],
      idNo: json['idNo'],
      name: json['name'],
      relationship: json['relationship'],
      tel: json['tel'],
    );
    /*address = json['address'];
    id = json['id'];
    idNo = json['idNo'];
    name = json['name'];
    relationship = json['relationship'];
    tel = json['tel'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['id'] = id;
    data['idNo'] = idNo;
    data['name'] = name;
    data['relationship'] = relationship;
    data['tel'] = tel;
    return data;
  }

  @override
  List<Object?> get props => [
        address,
        id,
        idNo,
        name,
        relationship,
        tel,
      ];
}

/*class BankDetails extends Equatable {
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? branch;
  int? id;
  String? otherMeans;
  String? otherMeansDetails;

  BankDetails(
      {this.accountName,
        this.accountNumber,
        this.bankName,
        this.branch,
        this.id,
        this.otherMeans,
        this.otherMeansDetails});

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      branch: json['branch'],
      id: json['id'],
      otherMeans: json['otherMeans'],
      otherMeansDetails: json['otherMeansDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountName'] = accountName;
    data['accountNumber'] = accountNumber;
    data['bankName'] = bankName;
    data['branch'] = branch;
    data['id'] = id;
    data['otherMeans'] = otherMeans;
    data['otherMeansDetails'] = otherMeansDetails;
    return data;
  }

  @override
  List<Object?> get props => [
    accountName,
    accountNumber,
    bankName,
    branch,
    id,
    otherMeans,
    otherMeansDetails
  ];
}*/
