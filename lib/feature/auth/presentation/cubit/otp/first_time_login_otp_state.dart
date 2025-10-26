part of 'first_time_login_otp_cubit.dart';

class FirstTimeLoginOtpState extends Equatable {
final String? exception;
  final UIState uiState;
  final OtpFirstLoginResponse? authLoginResponse;
  final bool isPasswordVisible;

  const FirstTimeLoginOtpState({
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

  FirstTimeLoginOtpState copyWith({
    String? exception,
    UIState? uiState,
    OtpFirstLoginResponse? authLoginResponse,
    bool? isPasswordVisible,
  }) {
    return FirstTimeLoginOtpState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      authLoginResponse: authLoginResponse ?? this.authLoginResponse,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
