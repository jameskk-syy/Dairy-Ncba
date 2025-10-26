import 'package:bloc/bloc.dart';
import 'package:dairytenantapp/core/domain/repository/core_repository.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:dairytenantapp/feature/auth/domain/models/reset_first_password.dart';
import 'package:dairytenantapp/feature/auth/domain/repository/login_repository.dart';
import 'package:equatable/equatable.dart';

part 'reset_password_state.dart';

class ResetPasswordDartCubit extends Cubit<ResetPasswordDartState> {
   final LoginRepository loginRepository;
  final CoreRepository coreRepository;
  ResetPasswordDartCubit(this.loginRepository, this.coreRepository) : super(ResetPasswordDartState());

 Future<void> resetFirstTimeLoginPassword(String token, String password) async {
    emit(state.copyWith(uiState: UIState.loading));
    try {
      final result = await loginRepository.resetFirstTimeLoginPassword(token, password);
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
