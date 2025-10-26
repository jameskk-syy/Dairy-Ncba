import 'package:dairytenantapp/core/data/dto/onboard_farmer_response_dto.dart';
import 'package:dairytenantapp/core/domain/models/pickup_location_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/models/counties_model.dart';
import '../../../../core/domain/models/routes_model.dart';
import '../../../../core/domain/models/sub_counties_model.dart';
import '../../../../core/domain/repository/core_repository.dart';
import '../../../../core/utils/utils.dart';
import '../../../collections/domain/model/custom_resp_model.dart';
import '../../domain/model/onboard_farmer_details.dart';
import '../../domain/model/onboard_farmer_response.dart';
import '../../domain/repository/farmers_repository.dart';

part 'add_farmer_state.dart';

class AddFarmerCubit extends Cubit<AddFarmerState> {
  final CoreRepository coreRepository;
  final FarmersRepository farmersRepository;
  AddFarmerCubit(this.coreRepository, this.farmersRepository)
    : super(const AddFarmerState());

  //Get Counties
  Future<void> getCounties() async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await coreRepository.getCounties();
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) => emit(
          state.copyWith(uiState: UIState.success, countiesResponseModel: data),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  //Get sub counties
  Future<void> getSubCounties() async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await coreRepository.getSubCounties();
      results.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) => emit(
          state.copyWith(
            uiState: UIState.success,
            subCountiesResponseModel: data,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  //Get pickup locations
  Future<void> getCollectorPickupLocations(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await coreRepository.getCollectorPickupLocations(
        collectorId,
      );
      results.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) => emit(
          state.copyWith(uiState: UIState.success, pickupLocationModel: data),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  //Get routes
  /*Future<void> getRoutes(int pickupLocationId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await coreRepository.getRoutes(pickupLocationId);
      results.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error, exception: mapFailureToMessage(failure))),
          (data) => emit(state.copyWith(
              uiState: UIState.success, routesResponseModel: data)));
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }*/

  //Add farmer
  Future<void> addFarmer(FarmerOnboardRequestModel farmer) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await farmersRepository.addFarmer(farmer);
      results.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) {
          debugPrint("$data");
          emit(
            state.copyWith(
              uiState: UIState.success,
              onBoardFarmerResponseModel: data,
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  //update farmer route
  Future<void> updateRoute(int farmerNo, int routeId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final results = await farmersRepository.updateRoute(farmerNo, routeId);
      results.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) {
          debugPrint("$data");
          emit(state.copyWith(uiState: UIState.success, customResponse: data));
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  /* void onStepContinue() {
    if (state.activeStep < (4 - 1)) {
      if (state.generalFormKey!.currentState!.validate()) {
        emit(state.copyWith(activeStep: state.activeStep + 1));
      }
    }
  }

  void onStepCancel() {
    if (state.activeStep == 0) {
      return;
    }
    emit(state.copyWith(activeStep: state.activeStep - 1));
  }

  void onStepTapped(int step) {
    emit(state.copyWith(activeStep: step));
  }*/
}
