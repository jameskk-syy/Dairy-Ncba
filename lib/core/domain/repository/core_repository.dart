import 'package:dartz/dartz.dart';
import '../../data/datasources/local/datasource/local/entity/routes_entity.dart';
import '../../data/dto/collectors_response_dto.dart';
import '../../data/dto/pickup_location.dart';
import '../../errors/failures.dart';
import '../models/can_response_model.dart';
import '../models/collector_routes_model.dart';
import '../models/counties_model.dart';
import '../models/routes_model.dart';
import '../models/sub_counties_model.dart';

abstract class CoreRepository {
  Future<Either<Failure, CanResponseModel>> getCanList();
  Future<Either<Failure, CountiesResponseModel>> getCounties();
  Future<Either<Failure, SubCountiesResponseModel>> getSubCounties();
  Future<Either<Failure, PickupLocationResponseDto>>
      getCollectorPickupLocations(int collectorId);
  Future<Either<Failure, RoutesResponseModel>> getRoutes();
  Future<Either<Failure, List<CollectorRoutesEntityResponse>>>
      getCollectorRoutes(int collectorId);
  Future<Either<Failure, List<UserData>>> getMilkCollectors();
  Future<Either<Failure, List<RoutesEntity>>> getMyRoutes(int collectorId);
}
