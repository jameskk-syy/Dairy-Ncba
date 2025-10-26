import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../../feature/collections/data/datasources/local/dao/collections_dao.dart';
import '../../../feature/collections/data/datasources/local/entity/collections_entity.dart';
import '../../../feature/farmers/data/datasources/local/converters/bank_details_type_converter.dart';
import '../../../feature/farmers/data/datasources/local/dao/farmers_dao.dart';
import '../../../feature/farmers/data/datasources/local/entity/farmer_entity.dart';
import '../datasources/local/datasource/local/dao/routes_dao.dart';
import '../datasources/local/datasource/local/entity/routes_entity.dart';

part 'app_database.g.dart';

@TypeConverters([
  BankDetailsTypeConverter,
])
@Database(version: 1, entities: [CollectionsEntity, FarmerEntity, RoutesEntity])
abstract class BahatisDatabase extends FloorDatabase {
  CollectionsDao get collectionsDao;
  FarmersDao get farmersDao;
  RoutesDao get routesDao;
}
