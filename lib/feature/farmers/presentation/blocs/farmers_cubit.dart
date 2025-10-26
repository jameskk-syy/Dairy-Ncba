import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/model/farmers_response_model.dart';
import '../../domain/repository/farmers_repository.dart';

part 'farmers_state.dart';

class FarmersCubit extends Cubit<FarmersState> {
  final FarmersRepository farmersRepository;
  FarmersCubit(this.farmersRepository) : super(const FarmersState());

  Future<void> getFarmers(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await farmersRepository.getFarmers(collectorId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success,
            farmersResponseModel: data,
            filteredFarmers: data));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> getMccFarmers(int mccId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await farmersRepository.getMccFarmers(mccId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success,
            farmersResponseModel: data,
            filteredFarmers: data));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  Future<void> searchFarmer(String query) async {
    emit(state.copyWith(searching: true));
    emit(state.copyWith(uiState: UIState.loading));
    if (query.isEmpty) {
      emit(state.copyWith(
          uiState: UIState.success,
          filteredFarmers: state.farmersResponseModel));
    } else {
      final filteredList = state.farmersResponseModel!.where((farmer) {
        return farmer.firstName!.toLowerCase().contains(query.toLowerCase()) ||
            farmer.idNumber!.toLowerCase().contains(query.toLowerCase()) ||
            farmer.farmerNo
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
      emit(state.copyWith(
          uiState: UIState.success,
          filteredFarmers: filteredList,
          searching: false));
    }
  }

  
  Future<void> searchMccFarmer(String query) async {
    emit(state.copyWith(searching: true));
    emit(state.copyWith(uiState: UIState.loading));
    if (query.isEmpty) {
      emit(state.copyWith(
          uiState: UIState.success,
          filteredFarmers: state.farmersResponseModel));
    } else {
      final filteredList = state.farmersResponseModel!.where((farmer) {
        return farmer.username!.toLowerCase().contains(query.toLowerCase()) ||
            farmer.idNumber!.toLowerCase().contains(query.toLowerCase()) ||
            farmer.farmerNo
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
      emit(state.copyWith(
          uiState: UIState.success,
          filteredFarmers: filteredList,
          searching: false));
    }
  }
}
