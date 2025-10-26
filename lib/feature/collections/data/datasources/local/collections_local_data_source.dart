import '../../../../../core/data/database/app_database.dart';
import '../../../../../core/data/dto/collection_response.dart';
import '../../../../../core/errors/exceptions.dart';
import 'entity/collections_entity.dart';

abstract class CollectionsLocalDataSource {
  Future<List<CollectionsEntity>> getAllCollections();
  Future<void> deleteAllCollections();
  Future<CollectionResponse> insertCollection(CollectionsEntity collection);
  Future<void> deleteCollectionById(int id);
}

class CollectionsLocalDataSourceImpl implements CollectionsLocalDataSource {
  final BahatisDatabase database;
  CollectionsLocalDataSourceImpl(this.database);

  @override
  Future<CollectionResponse> insertCollection(
      CollectionsEntity collection) async {
    try {
      final dao = database.collectionsDao;
      await dao.insertCollection(collection);
      return CollectionResponse(
          message: 'Collection added successfully', statusCode: 201);
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<void> deleteAllCollections() async {
    try {
      final dao = database.collectionsDao;
      await dao.deleteAllCollection();
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<List<CollectionsEntity>> getAllCollections() async {
    try {
      final dao = database.collectionsDao;
      final collections = await dao.getAllCollections();
      return collections;
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<void> deleteCollectionById(int id) async {
    try {
      final dao = database.collectionsDao;
      await dao.deleteCollectionById(id);
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }
}
