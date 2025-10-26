import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/domain/models/can_response_model.dart';
import '../../../../../core/domain/repository/core_repository.dart';
import '../../../../../core/utils/utils.dart';

part 'can_state.dart';

class CanCubit extends Cubit<CanState> {
  final CoreRepository coreRepository;
  CanCubit(this.coreRepository) : super(const CanState());

  Future<void> getCanLists() async {
    emit(state.copyWith(uiState: UIState.loading));
    try{
      final results = await coreRepository.getCanList();
      results.fold((failure) =>  emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
              (data) => emit(state.copyWith(uiState: UIState.success, cansModel: data)));
    } on Exception catch (e){
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
