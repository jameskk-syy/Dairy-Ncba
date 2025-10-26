import 'package:bloc/bloc.dart';
import 'package:dairytenantapp/core/data/dto/login_response_dto.dart';
import 'package:dairytenantapp/core/di/injector_container.dart';
import 'package:dairytenantapp/core/domain/repository/core_repository.dart';
import 'package:dairytenantapp/core/utils/user_data.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/auth/domain/models/validateotp.dart';
import 'package:dairytenantapp/feature/auth/domain/repository/login_repository.dart';
import 'package:dairytenantapp/feature/home/presentation/cubit/routes_cubit.dart';
import 'package:dairytenantapp/feature/totals/presentation/cubits/cubit/feeds_requests_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'validate_otp_state.dart';

class ValidateOtpCubit extends Cubit<ValidateOtpState> {
  final LoginRepository loginRepository;
  final CoreRepository coreRepository;

  ValidateOtpCubit(this.loginRepository, this.coreRepository)
      : super(const ValidateOtpState());
  /// Validate OTP method
  Future<void> validateOtp(String username, String otpCode) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await loginRepository.validateOtp(username, otpCode);
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) async {
          await saveMccId();
          await saveRouteId();
          emit(state.copyWith(
              uiState: UIState.success, authLoginResponse: data));
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }

  /// Toggle password visibility
  void obscurePassword(bool obscure) {
    emit(state.copyWith(
        isPasswordVisible: obscure, uiState: UIState.initial));
  }

  Future<void> saveMccId() async {
    final sharedPrefs = sl<SharedPreferences>();
    final cubit = sl<FeedsRequestsCubit>();
    await cubit.getCollectorPickupLocations(getUserData().id!).then((_) {
      final cubitState = cubit.state;
      if (cubitState.uiState == UIState.success) {
        sharedPrefs.setInt("locationId", cubitState.locationId!);
      }
    });
  }

  /// Save route ID
  Future<void> saveRouteId() async {
    final cubit = sl<RoutesCubit>();
    await cubit.getCollectorRoutes(getUserData().id!);
  }
}
