part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String? exception;
  final UIState uiState;
  final AuthLoginResponse? authLoginResponse;
  final bool isPasswordVisible;
  const LoginState({this.exception, this.uiState = UIState.initial, this.authLoginResponse, this.isPasswordVisible = false});

  @override
  List<Object?> get props => [uiState, authLoginResponse, exception, isPasswordVisible];

  LoginState copyWith({
    String? exception,
    UIState? uiState,
    AuthLoginResponse? authLoginResponse,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      authLoginResponse: authLoginResponse ?? this.authLoginResponse,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

}





