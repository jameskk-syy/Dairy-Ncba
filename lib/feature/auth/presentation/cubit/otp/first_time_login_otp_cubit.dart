import 'package:bloc/bloc.dart';
import 'package:dairytenantapp/core/domain/repository/core_repository.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/auth/domain/models/firstloginotpresponse.dart';
import 'package:dairytenantapp/feature/auth/domain/repository/login_repository.dart';
import 'package:equatable/equatable.dart';

part 'first_time_login_otp_state.dart';

class FirstTimeLoginOtpCubit extends Cubit<FirstTimeLoginOtpState> {
   final LoginRepository loginRepository;
  final CoreRepository coreRepository;

  FirstTimeLoginOtpCubit(this.loginRepository, this.coreRepository) : super(FirstTimeLoginOtpState());

 Future<void> validateFirstTimeLoginOtp(String username, String otpCode) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await loginRepository.validateFirstTimeLoginOtp(username, otpCode);
      result.fold(
        (failure) => emit(
          state.copyWith(
            uiState: UIState.error,
            exception: mapFailureToMessage(failure),
          ),
        ),
        (data) async {
          emit(state.copyWith(
              uiState: UIState.success, authLoginResponse: data));
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(uiState: UIState.error, exception: e.toString()));
    }
  }
}
