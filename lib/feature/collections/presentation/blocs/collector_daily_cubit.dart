import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/collections/domain/repository/collections_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/collection_totals_model.dart';

import 'package:equatable/equatable.dart';

part 'collector_daily_state.dart';

class CollectorDailyCubit extends Cubit<CollectorDailyState> {
  final CollectionsRepository collectionsRepository;

  CollectorDailyCubit(this.collectionsRepository)
    : super(const CollectorDailyState());

  Future<void> getCollectorsDailyTotals(
    int collectorId,
    int month,
    int year,
  ) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await collectionsRepository.getCollectorsDailySupply(
        collectorId,
        month,
        year,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) => emit(
          state.copyWith(uiState: UIState.success, collectionTotalsModel: data),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
