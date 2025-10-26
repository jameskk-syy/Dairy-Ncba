import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/model/totals_collection_history_model.dart';
import '../../domain/repository/aac_milk_collection_repository.dart';

part 'cummulator_stats_state.dart';

class CummulatorStatsCubit extends Cubit<CummulatorStatsState> {
  final AccMilkCollectionRepository repository;
  CummulatorStatsCubit(this.repository) : super(const CummulatorStatsState());

  FutureOr<void> getTotalMilkCollection(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await repository.getMilkAccumulationHistoryByDate(collectorId, date);
      result.fold(
        (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
        (data) => emit(state.copyWith(uiState: UIState.success, collections: data.entity!.length)),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  FutureOr<void> getMilkCollections(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await repository.getMilkAccumulationHistoryByDate(collectorId, date);
      result.fold(
            (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
            (data) => emit(state.copyWith(uiState: UIState.success, collectionsList: data.entity!)),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  FutureOr<void> getTotalRoutes(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await repository.getTotalRoutes(collectorId, date);
      result.fold(
        (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
        (data) => emit(state.copyWith(uiState: UIState.success, routes: data)),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  FutureOr<void> getTotalMilks(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await repository.getTotalMilkLts(collectorId, date);
      result.fold(
        (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
        (data) => emit(state.copyWith(uiState: UIState.success, totalMilk: data)),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

}
