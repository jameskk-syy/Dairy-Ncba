import 'package:bloc/bloc.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:equatable/equatable.dart';

import '../../data/dto/total_milk_accumulation_dto.dart';
import '../../domain/repository/aac_milk_collection_repository.dart';

part 'add_accumulative_collection_state.dart';

class AddAccumulativeCollectionCubit
    extends Cubit<AddAccumulativeCollectionState> {
  final AccMilkCollectionRepository accMilkCollectionRepository;
  AddAccumulativeCollectionCubit(this.accMilkCollectionRepository)
    : super(const AddAccumulativeCollectionState());

  Future<void> addAccumulativeCollection(
    MilkTotalsAccumulationDto request,
  ) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await accMilkCollectionRepository.addMilkAccumulation(
        request,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) => emit(
          state.copyWith(uiState: UIState.success, message: data.message),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
