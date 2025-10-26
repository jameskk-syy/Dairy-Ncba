import 'package:logger/logger.dart';

import '../../../../../core/data/database/app_database.dart';
import '../../../../../core/errors/exceptions.dart';
import 'entity/farmer_entity.dart';

abstract class FarmersLocalDataSource {
  Future<List<FarmerEntity>> getAllFarmers();
  Future<FarmerEntity?> getFarmerByFarmerNo(int farmerNo);
  Future<List<FarmerEntity>> getRouteFarmers(int collectorId);
  Future<void> deleteAllFarmers();
  Future<void> insertFarmer(List<FarmerEntity> farmer);
}

class FarmersLocalDataSourceImpl implements FarmersLocalDataSource {
  final BahatisDatabase database;
  FarmersLocalDataSourceImpl(this.database);

  @override
  Future<void> deleteAllFarmers() async {
    try {
      final logger = Logger();
      logger.i("deleting farmers ----------");
      final dao = database.farmersDao;
      await dao.deleteAllFarmers();
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<FarmerEntity?> getFarmerByFarmerNo(int farmerNo) async {
    try {
      final dao = database.farmersDao;
      final farmer = await dao.getFarmerByFarmerNo(farmerNo);
      return farmer;
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<List<FarmerEntity>> getAllFarmers() async {
    try {
      final dao = database.farmersDao;
      final farmers = await dao.getAllFarmers();
      print("sdfgggfdd ${farmers.length}");
      farmers.sort((a, b) => b.farmerNo.compareTo(a.farmerNo));
      return farmers;
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<void> insertFarmer(List<FarmerEntity> farmer) async {
    try {
      final logger = Logger();
      logger.i("inserting farmers ----------");
      logger.i("the farmers to be added are ${farmer.length}");
      final dao = database.farmersDao;
      dao.insertFarmers(farmer);
      logger.i("done inserting farmers");

      // Fetch the farmers right after insertion to confirm
    final insertedFarmers = await dao.getRouteFarmers();
    logger.i("Number of farmers in the database: ${insertedFarmers.length}");
    // for (var farmer in insertedFarmers) {
    //   logger.i("Farmer: ${farmer.lastName}, Farmer No: ${farmer.farmerNo}");
    // }
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<List<FarmerEntity>> getRouteFarmers(int collectorId) {
    return getAllFarmers();
  }
}
