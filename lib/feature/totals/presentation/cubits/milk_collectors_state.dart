part of 'milk_collectors_cubit.dart';

class MilkCollectorsState extends Equatable {
  final String? exception;
  final UIState uiState;
  final List<UserData>? userData;
  final List<RoutesEntityModel>? routes;
  const MilkCollectorsState({this.userData, this.uiState = UIState.initial, this.exception, this.routes});

  @override
  List<Object?> get props => [userData, uiState, exception];

  MilkCollectorsState copyWith({
    List<UserData>? userData,
    UIState? uiState,
    String? exception,
    List<RoutesEntityModel>? routes,
  }) {
    return MilkCollectorsState(
      userData: userData ?? this.userData,
      uiState: uiState ?? this.uiState,
      exception: exception ?? this.exception,
      routes: routes ?? this.routes,
    );
  }
}


