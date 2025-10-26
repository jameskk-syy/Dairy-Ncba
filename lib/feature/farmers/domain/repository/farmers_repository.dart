import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../collections/domain/model/custom_resp_model.dart';
import '../model/farmer_details_model.dart';
import '../model/farmers_response_model.dart';
import '../model/onboard_farmer_details.dart';
import '../model/onboard_farmer_response.dart';

abstract class FarmersRepository {
  Future<Either<Failure, List<FarmersEntityModel>>> getRouteFarmers(
      int collectorId);
  Future<Either<Failure, List<FarmersEntityModel>>> getFarmers(int collectorId);
  Future<Either<Failure, List<FarmersEntityModel>>> getAllRouteFarmers(
      int routeId);
  Future<Either<Failure, List<FarmersEntityModel>>> getMccFarmers(int mccId);
  Future<Either<Failure, FarmerDetailsEntityModel>> getFarmerDetails(
    int farmerNumber,
    /* int collectorId*/
  );
  Future<Either<Failure, FarmerDetailsEntityModel>> getFarmerInfo(
    int farmerNumber,
  );
  Future<Either<Failure, OnBoardFarmerResponseModel>> addFarmer(
      FarmerOnboardRequestModel farmer);
  Future<Either<Failure, CustomResponse>> updateRoute(
      int farmerNo, int routeId);
}
