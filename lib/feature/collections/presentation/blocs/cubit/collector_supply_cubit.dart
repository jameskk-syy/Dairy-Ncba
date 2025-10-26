import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/collections/domain/repository/collections_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/model/collection_totals_model.dart';
import 'package:equatable/equatable.dart';

part 'collector_supply_state.dart';

class CollectorSupplyCubit extends Cubit<CollectorSupplyState> {
  final CollectionsRepository collectionsRepository;

  CollectorSupplyCubit(this.collectionsRepository)
    : super(const CollectorSupplyState());

  Future<void> getCollectorsDailySupply(
    int year,
    int month,
    int collectorId,
  ) async {
    emit(state.copyWith(uiState: UIState.loading));

    try {
      final result = await collectionsRepository.getCollectorsDailySupply(
        year,
        month,
        collectorId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) {
          data.entity!.sort((a, b) {
            DateTime dateA = DateTime.parse(a.date!);
            DateTime dateB = DateTime.parse(b.date!);
            return dateB.compareTo(dateA);
          });
          emit(
            state.copyWith(
              uiState: UIState.success,
              collectionTotalsModel: data,
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
