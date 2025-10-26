import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/dto/total_milk_accumulation_dto.dart';
import '../model/add_milk_acc_response_model.dart';
import '../model/totals_collection_history_model.dart';

abstract class AccMilkCollectionRepository {
  Future<Either<Failure, AddMilkAccumulationResponse>> addMilkAccumulation(MilkTotalsAccumulationDto requestBody);
  Future<Either<Failure, TotalsCollectionHistoryModel>> getMilkAccumulationHistory(int collectorId);
  Future<Either<Failure, int>> getTotalRoutes(int collectorId, String date);
  Future<Either<Failure, double>> getTotalMilkLts(int collectorId, String date);
  Future<Either<Failure, TotalsCollectionHistoryModel>> getMilkAccumulationHistoryByDate(int collectorId, String date);
}