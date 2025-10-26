import 'package:dairytenantapp/feature/collections/domain/model/monthly_totals_model.dart';

class MonthlyTotals extends MonthlyTotalsModel {
  const MonthlyTotals({super.message, super.statusCode, super.entity});

  factory MonthlyTotals.fromJson(Map<String, dynamic> json) {
    return MonthlyTotals(
      message: json['message'],
      statusCode: json['statusCode'],
      entity: List<MonthlyTotalsModelEntity>.from(
        json['entity'].map((item) => MonthlyTotalsEntity.fromJson(item)),
      ),
    );
  }
}

class MonthlyTotalsEntity extends MonthlyTotalsModelEntity {
  const MonthlyTotalsEntity({super.collected, super.supply});

  factory MonthlyTotalsEntity.fromJson(Map<String, dynamic> json) {
    return MonthlyTotalsEntity(
      collected: json['monthlyTotal'],
      supply: json['monthlySupply'],
    );
  }
}
