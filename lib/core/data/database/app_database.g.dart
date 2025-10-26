// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $BahatisDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $BahatisDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $BahatisDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<BahatisDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorBahatisDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BahatisDatabaseBuilderContract databaseBuilder(String name) =>
      _$BahatisDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BahatisDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$BahatisDatabaseBuilder(null);
}

class _$BahatisDatabaseBuilder implements $BahatisDatabaseBuilderContract {
  _$BahatisDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $BahatisDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $BahatisDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<BahatisDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$BahatisDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$BahatisDatabase extends BahatisDatabase {
  _$BahatisDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CollectionsDao? _collectionsDaoInstance;

  FarmersDao? _farmersDaoInstance;

  RoutesDao? _routesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `collections` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `collectorId` INTEGER NOT NULL, `routeId` INTEGER NOT NULL, `farmerNumber` INTEGER NOT NULL, `quantity` REAL NOT NULL, `session` TEXT NOT NULL, `latitude` TEXT, `longitude` TEXT, `event` TEXT NOT NULL, `status` TEXT NOT NULL, `updatedStatus` TEXT NOT NULL, `paymentStatus` TEXT NOT NULL, `collectionDate` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `farmers` (`id` INTEGER NOT NULL, `username` TEXT NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `idNumber` TEXT NOT NULL, `farmerNo` INTEGER NOT NULL, `mobileNo` TEXT NOT NULL, `alternativeMobileNo` TEXT NOT NULL, `memberType` TEXT NOT NULL, `address` TEXT NOT NULL, `paymentFreequency` TEXT NOT NULL, `paymentDate` TEXT NOT NULL, `paymentMode` TEXT NOT NULL, `createdAt` TEXT NOT NULL, `deletedFlag` TEXT NOT NULL, `deletedOn` TEXT NOT NULL, `location` TEXT NOT NULL, `subLocation` TEXT NOT NULL, `village` TEXT NOT NULL, `countyFk` INTEGER NOT NULL, `subcountyFk` INTEGER NOT NULL, `wardFk` INTEGER NOT NULL, `noOfCows` INTEGER NOT NULL, `routeFk` INTEGER NOT NULL, `transportMeans` TEXT NOT NULL, `gender` TEXT NOT NULL, `routeName` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `routes` (`id` INTEGER NOT NULL, `route` TEXT NOT NULL, `routeCode` TEXT NOT NULL, `collectors` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CollectionsDao get collectionsDao {
    return _collectionsDaoInstance ??=
        _$CollectionsDao(database, changeListener);
  }

  @override
  FarmersDao get farmersDao {
    return _farmersDaoInstance ??= _$FarmersDao(database, changeListener);
  }

  @override
  RoutesDao get routesDao {
    return _routesDaoInstance ??= _$RoutesDao(database, changeListener);
  }
}

class _$CollectionsDao extends CollectionsDao {
  _$CollectionsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _collectionsEntityInsertionAdapter = InsertionAdapter(
            database,
            'collections',
            (CollectionsEntity item) => <String, Object?>{
                  'id': item.id,
                  'collectorId': item.collectorId,
                  'routeId': item.routeId,
                  'farmerNumber': item.farmerNumber,
                  'quantity': item.quantity,
                  'session': item.session,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'event': item.event,
                  'status': item.status,
                  'updatedStatus': item.updatedStatus,
                  'paymentStatus': item.paymentStatus,
                  'collectionDate': item.collectionDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CollectionsEntity> _collectionsEntityInsertionAdapter;

  @override
  Future<List<CollectionsEntity>> getAllCollections() async {
    return _queryAdapter.queryList('SELECT * FROM collections',
        mapper: (Map<String, Object?> row) => CollectionsEntity(
            id: row['id'] as int?,
            collectorId: row['collectorId'] as int,
            event: row['event'] as String,
            farmerNumber: row['farmerNumber'] as int,
            latitude: row['latitude'] as String?,
            longitude: row['longitude'] as String?,
            paymentStatus: row['paymentStatus'] as String,
            quantity: row['quantity'] as double,
            routeId: row['routeId'] as int,
            session: row['session'] as String,
            status: row['status'] as String,
            updatedStatus: row['updatedStatus'] as String,
            collectionDate: row['collectionDate'] as String));
  }

  @override
  Future<void> deleteAllCollection() async {
    await _queryAdapter.queryNoReturn('DELETE FROM collections');
  }

  @override
  Future<void> deleteCollectionById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM collections WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertCollection(CollectionsEntity collection) async {
    await _collectionsEntityInsertionAdapter.insert(
        collection, OnConflictStrategy.replace);
  }
}

class _$FarmersDao extends FarmersDao {
  _$FarmersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _farmerEntityInsertionAdapter = InsertionAdapter(
            database,
            'farmers',
            (FarmerEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'idNumber': item.idNumber,
                  'farmerNo': item.farmerNo,
                  'mobileNo': item.mobileNo,
                  'alternativeMobileNo': item.alternativeMobileNo,
                  'memberType': item.memberType,
                  'address': item.address,
                  'paymentFreequency': item.paymentFreequency,
                  'paymentDate': item.paymentDate,
                  'paymentMode': item.paymentMode,
                  'createdAt': item.createdAt,
                  'deletedFlag': item.deletedFlag,
                  'deletedOn': item.deletedOn,
                  'location': item.location,
                  'subLocation': item.subLocation,
                  'village': item.village,
                  'countyFk': item.countyFk,
                  'subcountyFk': item.subcountyFk,
                  'wardFk': item.wardFk,
                  'noOfCows': item.noOfCows,
                  'routeFk': item.routeFk,
                  'transportMeans': item.transportMeans,
                  'gender': item.gender,
                  'routeName': item.routeName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FarmerEntity> _farmerEntityInsertionAdapter;

  @override
  Future<List<FarmerEntity>> getAllFarmers() async {
    return _queryAdapter.queryList('SELECT * FROM farmers',
        mapper: (Map<String, Object?> row) => FarmerEntity(
            gender: row['gender'] as String,
            transportMeans: row['transportMeans'] as String,
            farmerNo: row['farmerNo'] as int,
            username: row['username'] as String,
            subLocation: row['subLocation'] as String,
            location: row['location'] as String,
            createdAt: row['createdAt'] as String,
            idNumber: row['idNumber'] as String,
            mobileNo: row['mobileNo'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            memberType: row['memberType'] as String,
            paymentFreequency: row['paymentFreequency'] as String,
            firstName: row['firstName'] as String,
            village: row['village'] as String,
            subcountyFk: row['subcountyFk'] as int,
            routeFk: row['routeFk'] as int,
            paymentDate: row['paymentDate'] as String,
            deletedOn: row['deletedOn'] as String,
            countyFk: row['countyFk'] as int,
            id: row['id'] as int,
            noOfCows: row['noOfCows'] as int,
            alternativeMobileNo: row['alternativeMobileNo'] as String,
            deletedFlag: row['deletedFlag'] as String,
            paymentMode: row['paymentMode'] as String,
            routeName: row['routeName'] as String,
            wardFk: row['wardFk'] as int));
  }

  @override
  Future<List<FarmerEntity>> getRouteFarmers() async {
    return _queryAdapter.queryList('SELECT * FROM farmers',
        mapper: (Map<String, Object?> row) => FarmerEntity(
            gender: row['gender'] as String,
            transportMeans: row['transportMeans'] as String,
            farmerNo: row['farmerNo'] as int,
            username: row['username'] as String,
            subLocation: row['subLocation'] as String,
            location: row['location'] as String,
            createdAt: row['createdAt'] as String,
            idNumber: row['idNumber'] as String,
            mobileNo: row['mobileNo'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            memberType: row['memberType'] as String,
            paymentFreequency: row['paymentFreequency'] as String,
            firstName: row['firstName'] as String,
            village: row['village'] as String,
            subcountyFk: row['subcountyFk'] as int,
            routeFk: row['routeFk'] as int,
            paymentDate: row['paymentDate'] as String,
            deletedOn: row['deletedOn'] as String,
            countyFk: row['countyFk'] as int,
            id: row['id'] as int,
            noOfCows: row['noOfCows'] as int,
            alternativeMobileNo: row['alternativeMobileNo'] as String,
            deletedFlag: row['deletedFlag'] as String,
            paymentMode: row['paymentMode'] as String,
            routeName: row['routeName'] as String,
            wardFk: row['wardFk'] as int));
  }

  @override
  Future<FarmerEntity?> getFarmerByFarmerNo(int farmerNo) async {
    return _queryAdapter.query('SELECT * FROM farmers WHERE farmerNo = ?1',
        mapper: (Map<String, Object?> row) => FarmerEntity(
            gender: row['gender'] as String,
            transportMeans: row['transportMeans'] as String,
            farmerNo: row['farmerNo'] as int,
            username: row['username'] as String,
            subLocation: row['subLocation'] as String,
            location: row['location'] as String,
            createdAt: row['createdAt'] as String,
            idNumber: row['idNumber'] as String,
            mobileNo: row['mobileNo'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            memberType: row['memberType'] as String,
            paymentFreequency: row['paymentFreequency'] as String,
            firstName: row['firstName'] as String,
            village: row['village'] as String,
            subcountyFk: row['subcountyFk'] as int,
            routeFk: row['routeFk'] as int,
            paymentDate: row['paymentDate'] as String,
            deletedOn: row['deletedOn'] as String,
            countyFk: row['countyFk'] as int,
            id: row['id'] as int,
            noOfCows: row['noOfCows'] as int,
            alternativeMobileNo: row['alternativeMobileNo'] as String,
            deletedFlag: row['deletedFlag'] as String,
            paymentMode: row['paymentMode'] as String,
            routeName: row['routeName'] as String,
            wardFk: row['wardFk'] as int),
        arguments: [farmerNo]);
  }

  @override
  Future<void> deleteAllFarmers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM farmers');
  }

  @override
  Future<void> insertFarmers(List<FarmerEntity> farmer) async {
    await _farmerEntityInsertionAdapter.insertList(
        farmer, OnConflictStrategy.replace);
  }
}

class _$RoutesDao extends RoutesDao {
  _$RoutesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _routesEntityInsertionAdapter = InsertionAdapter(
            database,
            'routes',
            (RoutesEntity item) => <String, Object?>{
                  'id': item.id,
                  'route': item.route,
                  'routeCode': item.routeCode,
                  'collectors': item.collectors
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RoutesEntity> _routesEntityInsertionAdapter;

  @override
  Future<List<RoutesEntity>> getAllRoutes() async {
    return _queryAdapter.queryList('SELECT * FROM routes',
        mapper: (Map<String, Object?> row) => RoutesEntity(
            id: row['id'] as int,
            route: row['route'] as String,
            routeCode: row['routeCode'] as String,
            collectors: row['collectors'] as String));
  }

  @override
  Future<void> deleteAllRoutes() async {
    await _queryAdapter.queryNoReturn('DELETE FROM routes');
  }

  @override
  Future<void> insertRoutes(List<RoutesEntity> routesEntity) async {
    await _routesEntityInsertionAdapter.insertList(
        routesEntity, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _bankDetailsTypeConverter = BankDetailsTypeConverter();
