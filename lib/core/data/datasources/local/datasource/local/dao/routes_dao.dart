import 'package:floor/floor.dart';

import '../../../../../../utils/constants.dart';
import '../entity/routes_entity.dart';


@dao
abstract class RoutesDao{
  //iNSERT
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRoutes(List<RoutesEntity> routesEntity);

  //SELECT ALL
  @Query('SELECT * FROM ${Constants.kRoutesTable}')
  Future<List<RoutesEntity>> getAllRoutes();

  //DELETE ALL
  @Query('DELETE FROM ${Constants.kRoutesTable}')
  Future<void> deleteAllRoutes();
}