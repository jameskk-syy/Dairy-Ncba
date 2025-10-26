import 'package:dairytenantapp/core/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: Constants.kRoutesTable)
class RoutesEntity extends Equatable {
  @primaryKey
  final int id;
  final String route;
  final String routeCode;
  final String collectors;

  const RoutesEntity({
    required this.id,
    required this.route,
    required this.routeCode,
    required this.collectors,
  });

  @override
  List<Object?> get props => [id, route, routeCode, collectors];
}
