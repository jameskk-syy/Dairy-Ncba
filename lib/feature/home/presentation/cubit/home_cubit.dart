import '../../../../core/data/datasources/local/datasource/core_local_datasource.dart';
import '../../../../core/utils/user_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/domain/repository/core_repository.dart';
import '../../../../core/utils/utils.dart';
import '../../../collections/domain/model/collection_history_model.dart';
import '../../../collections/domain/model/route_totals_model.dart';
import '../../../collections/domain/repository/collections_repository.dart';
import '../../../farmers/domain/repository/farmers_repository.dart';
import '../../../collections/domain/model/monthly_totals_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FarmersRepository farmersRepository;
  final CollectionsRepository collectionsRepository;
  final CoreRepository coreRepository;
  final CoreLocalDataSource coreLocalDataSource;

  HomeCubit(
      this.farmersRepository, this.collectionsRepository, this.coreRepository, this.coreLocalDataSource)
      : super(const HomeState());

  Future<void> getTotalFarmers(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await farmersRepository.getRouteFarmers(collectorId);
      print("total farmers data.length}");
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        print("total farmers ${data.length}");
        emit(state.copyWith(
            uiState: UIState.success, totalFarmers: data.length));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getTotalCollections(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result =
          await collectionsRepository.getCollectionsByDate(collectorId, date);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success,
              totalCollections: data.entity!.length)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getTotalLitres(int collectorId, String date) async {
    final log = Logger();
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result =
          await collectionsRepository.getCollectionsByDate(collectorId, date);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        double totalLitres = 0.0;
        for (var element in data.entity!) {
          totalLitres += element.quantity!;
          log.i('Total Litres: $totalLitres');
          debugPrint('total: $totalLitres');
        }
        emit(
            state.copyWith(uiState: UIState.success, totalLitres: totalLitres));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getTotalSubCollections(String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await collectionsRepository.getCollectionsByDate(42, date);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, totalSubColl: data.entity!.length)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getSubCollectorsTotals(String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final response = await collectionsRepository.getCollectionsByDate(
          getUserData().id!, date);
      response.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        final Logger logger = Logger();
        logger.i("information received $data");
        double totalSubLitres = 0.0;
        final routeSubTotals = groupByRouteAndSumQuantity(data.entity!);
        logger.i("mapped data $routeSubTotals");
        emit(state.copyWith(
            uiState: UIState.success, routeTotals: routeSubTotals));
        for (var element in data.entity!) {
          totalSubLitres += element.quantity!;
          // logger.i("total sub litres: $totalSubLitres");
        }
        emit(state.copyWith(
          uiState: UIState.success,
          totalSubLitres: totalSubLitres,
        ));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  List<RouteTotalsModel> groupByRouteAndSumQuantity(
      List<CollectionHistoryEntityModel> data) {
    // Create a map to store the sum of quantities for each route
    final Map<String, double> routeQuantityMap = {};

    // Iterate through each item in the data list
    for (var item in data) {
      // If the route is already in the map, add the quantity to the existing total
      if (routeQuantityMap.containsKey(item.route)) {
        routeQuantityMap[item.route!] =
            routeQuantityMap[item.route]! + (item.quantity ?? 0.0);
      } else {
        // If the route is not in the map, add it with the initial quantity
        routeQuantityMap[item.route!] = item.quantity ?? 0;
      }
    }

    // Convert the map to a list of RouteQuantity objects
    return routeQuantityMap.entries
        .map((entry) =>
            RouteTotalsModel(route: entry.key, quantity: entry.value))
        .toList();
  }

  Future<void> getMonthlyTotals(int month, int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final response =
          await collectionsRepository.getMonthlyTotals(collectorId, month);
      debugPrint("$collectorId $month");
      response.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success,
            monthlyTotalsModelEntity: data.entity!.first,
            monthlyTotalsModel: data));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getCollectorRoutes(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await coreRepository.getCollectorRoutes(collectorId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success, centerName: data[0].pickUpLocation));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

    Future<void> getMyRoutes(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await coreRepository.getMyRoutes(collectorId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success, ));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> deleteAllRoutes() async {
    // emit(state.copyWith(uiState: UIState.loading));
    try {
      await coreLocalDataSource.deleteAllRoutes();
      // result.fold(
      //     (failure) => emit(state.copyWith(
      //         uiState: UIState.error,
      //         exception: mapFailureToMessage(failure))), (data) {
      //   emit(state.copyWith(
      //       uiState: UIState.success, centerName: data[0].pickUpLocation));
      // });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
