import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../feature/fieldofficer/mccs/data/mcc_repository.dart';
import '../../../../core/domain/models/pickup_location_model.dart';
import '../../../../core/domain/models/routes_model.dart';
import '../../../../core/utils/utils.dart';
import '../domain/route_totals_dto.dart';

part 'mcc_state.dart';

class MccCubit extends Cubit<MccState> {
  final MccRepository mccRepository;
  MccCubit(this.mccRepository) : super(const MccState());

  //Get pickup locations
  Future<void> getPickupLocations() async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await mccRepository.getPickupLocations();
      results.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              exception: mapFailureToMessage(failure))), (data) {
        emit(state.copyWith(
            uiState: UIState.success, pickUpLocationModel: data.entity));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  //Get mcc routes
  Future<void> getMccRoutes(int mccId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await mccRepository.getMccRoutes(mccId);
      results.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, routesList: data.entity)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  //Get mcc routes
  Future<void> getRouteSummary(int routeId, int month, String year) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await mccRepository.getRouteSummary(routeId, month, year);
      results.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, routeSummary: data.routeList)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
