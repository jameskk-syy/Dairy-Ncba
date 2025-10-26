import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/model/collection_history_model.dart';
import '../../domain/repository/collections_repository.dart';

part 'filter_collections_state.dart';

class FilterCollectionsCubit extends Cubit<FilterCollectionsState> {
  final CollectionsRepository collectionsRepository;
  FilterCollectionsCubit(this.collectionsRepository) : super(const FilterCollectionsState());

  Future<void> getFilteredCollections(
      {required int collectorId,
      required String farmerNo,
      required String startDate,
      required String endDate,
      required String session}) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result =
      await collectionsRepository.getFarmerCollectionsByDateRange(collectorId, farmerNo, startDate, endDate, session);
      result.fold(
              (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
              (data) => emit(state.copyWith(
              uiState: UIState.success, collectionHistoryModel: data)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  FutureOr<void> getCollectionByDate({required int collectorId, required String date}) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await collectionsRepository.getCollectionsByDate(collectorId, date);
      result.fold(
              (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
              (data) => emit(state.copyWith(uiState: UIState.success, collectionHistoryModel: data)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
