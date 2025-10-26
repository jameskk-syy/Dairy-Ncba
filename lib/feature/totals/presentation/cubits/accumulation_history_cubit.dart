import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/model/totals_collection_history_model.dart';
import '../../domain/repository/aac_milk_collection_repository.dart';

part 'accumulation_history_state.dart';

class AccumulationHistoryCubit extends Cubit<AccumulationHistoryState> {
  final AccMilkCollectionRepository repository;
  AccumulationHistoryCubit(this.repository) : super(const AccumulationHistoryState());

  FutureOr<void> getMilkAccumulationHistory(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await repository.getMilkAccumulationHistory(collectorId);
      result.fold(
        (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
        (data) => emit(state.copyWith(uiState: UIState.success, data: data.entity)),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  FutureOr<void> getMilkAccumulationHistoryByDate(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await repository.getMilkAccumulationHistoryByDate(collectorId, date);
      result.fold(
        (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
        (data) => emit(state.copyWith(uiState: UIState.success, data: data.entity)),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
