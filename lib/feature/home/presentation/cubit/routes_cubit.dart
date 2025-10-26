import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/domain/models/collector_routes_model.dart';
import '../../../../core/domain/repository/core_repository.dart';
import '../../../../core/utils/utils.dart';

part 'routes_state.dart';

class RoutesCubit extends Cubit<RoutesState> {
  final CoreRepository coreRepository;

  RoutesCubit(this.coreRepository) : super(const RoutesState());

  Future<void> getCollectorRoutes(int collectorId) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await coreRepository.getCollectorRoutes(collectorId);
      result.fold(
          (failure) => emit(state.copyWith(
              uiState: UIState.error,
              message: mapFailureToMessage(failure))), (data) {
        int routeId = data[0].id!;

        saveRouteId(routeId);
        emit(state.copyWith(
          uiState: UIState.success,
          routes: data,
        ));
      });
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, message: e.toString()));
    }
  }

  saveRouteId(int routeId) async {
    final sharedPrefs = sl<SharedPreferences>();
    sharedPrefs.setInt("routeId", routeId);
  }
}
