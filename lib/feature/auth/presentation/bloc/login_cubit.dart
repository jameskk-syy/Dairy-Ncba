import 'package:dairytenantapp/core/data/dto/login_response_dto.dart';
import 'package:dairytenantapp/core/domain/repository/core_repository.dart';
import 'package:dairytenantapp/feature/auth/domain/models/loginResponse.dart';
import 'package:dairytenantapp/feature/home/presentation/cubit/routes_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/user_data.dart';
import '../../../../core/utils/utils.dart';
import '../../../totals/presentation/cubits/cubit/feeds_requests_cubit.dart';
import '../../domain/repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  final CoreRepository coreRepository;
  LoginCubit(this.loginRepository, this.coreRepository)
    : super(const LoginState());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await loginRepository.login(username, password);
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) {
          emit(state.copyWith(uiState: UIState.success, authLoginResponse: data));
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
  void obscurePassword(bool obscure) {
    emit(state.copyWith(isPasswordVisible: obscure, uiState: UIState.initial));
  }

  saveMccId() async {
    final sharedPrefs = sl<SharedPreferences>();
    final cubit = sl<FeedsRequestsCubit>();
    await cubit.getCollectorPickupLocations(getUserData().id!).then((value) {
      final state = cubit.state;

      if (state.uiState == UIState.success) {
        sharedPrefs.setInt("locationId", state.locationId!);
      }
    });
  }

  saveRouteId() async {
    final cubit = sl<RoutesCubit>();
    await cubit.getCollectorRoutes(getUserData().id!).then((value) {});
  }
}
