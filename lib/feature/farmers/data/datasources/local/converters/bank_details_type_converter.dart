import 'dart:convert';

import 'package:dairytenantapp/feature/farmers/domain/model/farmers_response_model.dart';
import 'package:floor/floor.dart';

class BankDetailsTypeConverter extends TypeConverter<BankDetailsModel, String> {
  @override
  BankDetailsModel decode(String databaseValue) {
    Map<String, dynamic> map = json.decode(databaseValue);
    return BankDetailsModel(
      id: map['id'],
      bankName: map['bankName'],
      accountName: map['accountName'],
      accountNumber: map['accountNumber'],
      branch: map['branch'],
      otherMeans: map['otherMeans'],
      otherMeansDetails: map['otherMeansDetails'],
    );
  }

  @override
  String encode(BankDetailsModel value) {
    return json.encode({
      'id': value.id,
      'bankName': value.bankName,
      'accountName': value.accountName,
      'accountNumber': value.accountNumber,
      'branch': value.branch,
      'otherMeans': value.otherMeans,
      'otherMeansDetails': value.otherMeansDetails,
    });
  }
}
