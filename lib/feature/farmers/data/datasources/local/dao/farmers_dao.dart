import 'package:floor/floor.dart';

import '../../../../../../core/utils/constants.dart';
import '../entity/farmer_entity.dart';

@dao
abstract class FarmersDao {
  // INSERT FARMERS
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFarmers(List<FarmerEntity> farmer);

  // GET ALL FARMERS
  @Query('SELECT * FROM ${Constants.kFarmersTable}')
  Future<List<FarmerEntity>> getAllFarmers();

  //get route farmers
  @Query(
      'SELECT * FROM ${Constants.kFarmersTable}')
  Future<List<FarmerEntity>> getRouteFarmers();

  // get farmer farmer by farmer number
  @Query('SELECT * FROM ${Constants.kFarmersTable} WHERE farmerNo = :farmerNo')
  Future<FarmerEntity?> getFarmerByFarmerNo(int farmerNo);

  // DELETE ALL FARMERS
  @Query('DELETE FROM ${Constants.kFarmersTable}')
  Future<void> deleteAllFarmers();
}
