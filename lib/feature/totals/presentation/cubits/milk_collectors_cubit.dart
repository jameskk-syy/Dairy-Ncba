import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/dto/collectors_response_dto.dart';
import '../../../../core/domain/models/routes_model.dart';
import '../../../../core/domain/repository/core_repository.dart';
import '../../../../core/utils/utils.dart';

part 'milk_collectors_state.dart';

class MilkCollectorsCubit extends Cubit<MilkCollectorsState> {
  final CoreRepository coreRepository;

  MilkCollectorsCubit(this.coreRepository) : super(const MilkCollectorsState());

  FutureOr<void> getMilkCollectors() async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await coreRepository.getMilkCollectors();
      result.fold(
        (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
        (data) async {
          final routes = await coreRepository.getRoutes();
          routes.fold(
            (failure) => emit(state.copyWith(uiState: UIState.error, exception: mapFailureToMessage(failure))),
            (routesData) => emit(state.copyWith(uiState: UIState.success, userData: data, routes: routesData.entity)),
          );
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  /*FutureOr<void> getRoutes() async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await coreRepository.getRoutes();
      result.fold(
        (failure) => emit(state.copyWith(
            uiState: UIState.error, exception: mapFailureToMessage(failure))),
        (data) =>
            emit(state.copyWith(uiState: UIState.success, routes: data.entity)),
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }*/

}
