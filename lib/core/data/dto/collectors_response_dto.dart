import 'package:equatable/equatable.dart';

class MilkCollectorsDto extends Equatable{
  List<UserData>? userData;

  MilkCollectorsDto({this.userData});

  factory MilkCollectorsDto.fromJson(Map<String, dynamic> json) {
    return MilkCollectorsDto(
      userData: json['userData'] != null
          ? (json['userData'] as List).map((i) => UserData.fromJson(i)).toList()
          : null,
    );
  }

  @override
  List<Object?> get props => [userData];
}

class UserData extends Equatable {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? pickUpLocation;
  String? email;
  String? mobile;
  String? status;
  String? creationDate;
  String? updateDate;
  String? deletedDate;
  int? isLoggedIn;
  List<Roles>? roles;

  UserData(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.pickUpLocation,
      this.email,
      this.mobile,
      this.status,
      this.creationDate,
      this.updateDate,
      this.deletedDate,
      this.isLoggedIn,
      this.roles});

 factory UserData.fromJson(Map<String, dynamic> json) {
   return UserData(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      pickUpLocation: json['pickUpLocation'],
      email: json['email'],
      mobile: json['mobile'],
      status: json['status'],
      creationDate: json['creationDate'],
      updateDate: json['updateDate'],
      deletedDate: json['deletedDate'],
      isLoggedIn: json['isLoggedIn'],
      roles: json['roles'] != null ? (json['roles'] as List).map((i) => Roles.fromJson(i)).toList() : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        firstName,
        lastName,
        pickUpLocation,
        email,
        mobile,
        status,
        creationDate,
        updateDate,
        deletedDate,
        isLoggedIn,
        roles
      ];

}

class Roles extends Equatable {
  String? name;
  //List<AccessRights>? accessRights;
  Roles({this.name});

 factory Roles.fromJson(Map<String, dynamic> json) {
   return Roles(
     name: json['name'],
   );
  }
  @override
  List<Object?> get props => [name];

}

class AccessRights {
  String? name;
  String? accessRights;

  AccessRights({this.name, this.accessRights});

 factory AccessRights.fromJson(Map<String, dynamic> json) {
   return AccessRights(
     name: json['name'],
     accessRights: json['accessRights'],
   );
  }

}
