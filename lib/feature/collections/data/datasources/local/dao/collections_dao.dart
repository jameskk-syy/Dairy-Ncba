import 'package:floor/floor.dart';

import '../../../../../../core/utils/constants.dart';
import '../entity/collections_entity.dart';

@dao
abstract class CollectionsDao {
  //Insert new collection to Db
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCollection(CollectionsEntity collection);

  //Get all collections
  @Query('SELECT * FROM ${Constants.kCollectionsTable}')
  Future<List<CollectionsEntity>> getAllCollections();

  //Delete all collections
  @Query('DELETE FROM ${Constants.kCollectionsTable}')
  Future<void> deleteAllCollection();

  //Delete collection by id
  @Query('DELETE FROM ${Constants.kCollectionsTable} WHERE id = :id')
  Future<void> deleteCollectionById(int id);
}