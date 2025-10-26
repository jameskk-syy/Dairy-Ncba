import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/model/collection_history_model.dart';
import '../../domain/model/custom_resp_model.dart';
import '../../domain/repository/collections_repository.dart';

part 'today_collection_state.dart';

class TodayCollectionCubit extends Cubit<TodayCollectionState> {
  final CollectionsRepository collectionsRepository;
  TodayCollectionCubit(this.collectionsRepository)
      : super(const TodayCollectionState());

  Future<void> getCollectionHistory(int collectorId, String date) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result =
          await collectionsRepository.getCollectionsByDate(collectorId, date);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, collectionHistoryModel: data)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> returnDelivery(int collectionId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await collectionsRepository.returnDelivery(collectionId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, deliveryReturnResponse: data)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Stream<void> getCollectionHistoryStream(int collectorId, String date) async* {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result =
          await collectionsRepository.getCollectionsByDate(collectorId, date);
      yield* result.fold(
        (failure) async* {
          yield state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure));
        },
        (data) async* {
          yield state.copyWith(
              uiState: UIState.success, collectionHistoryModel: data);
        },
      );
    } catch (e) {
      yield state.copyWith(uiState: UIState.error, exception: e.toString());
    }
  }

  /*Stream<void> getCollectionHistoryStream(int collectorId, String date) async* {
    yield state.copyWith(uiState: UIState.loading);
    try {
      final result = await collectionsRepository.getCollectionsByDate(collectorId, date);
      result.fold(
              (failure) => yield state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure)),
    (data) => yield state.copyWith(uiState: UIState.success, collectionHistoryModel: data)
    );
    } catch (e) {
    yield state.copyWith(uiState: UIState.error, exception: e.toString());
    }
  }*/
}
