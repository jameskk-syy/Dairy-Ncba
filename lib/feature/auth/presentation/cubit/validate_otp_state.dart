part of 'validate_otp_cubit.dart';

class ValidateOtpState extends Equatable {
  final String? exception;
  final UIState uiState;
  final LoginResponse? authLoginResponse;
  final bool isPasswordVisible;

  const ValidateOtpState({
    this.exception,
    this.uiState = UIState.initial,
    this.authLoginResponse,
    this.isPasswordVisible = false,
  });

  @override
  List<Object?> get props => [
        uiState,
        authLoginResponse,
        exception,
        isPasswordVisible,
      ];

  ValidateOtpState copyWith({
    String? exception,
    UIState? uiState,
    LoginResponse? authLoginResponse,
    bool? isPasswordVisible,
  }) {
    return ValidateOtpState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      authLoginResponse: authLoginResponse ?? this.authLoginResponse,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
