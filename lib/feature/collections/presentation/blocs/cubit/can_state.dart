part of 'can_cubit.dart';

class CanState extends Equatable {
  final CanResponseModel? cansModel;
  final String? exception;
  final UIState uiState;
  const CanState({this.uiState = UIState.initial, this.cansModel, this.exception});

  @override
  List<Object?> get props => [uiState, cansModel, exception];

  CanState copyWith({
     CanResponseModel? cansModel,
     String? exception,
     UIState? uiState,
}) {
    return CanState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
        cansModel: cansModel ?? this.cansModel
    );
  }

}

