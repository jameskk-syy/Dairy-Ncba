part of 'reset_password_cubit.dart';
class ResetPasswordDartState extends Equatable {
final String? exception;
  final UIState uiState;
  final PasswordChangeResponse? authLoginResponse;
  final bool isPasswordVisible;

  const ResetPasswordDartState({
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

  ResetPasswordDartState copyWith({
    String? exception,
    UIState? uiState,
    PasswordChangeResponse? authLoginResponse,
    bool? isPasswordVisible,
  }) {
    return ResetPasswordDartState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      authLoginResponse: authLoginResponse ?? this.authLoginResponse,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
