part of 'routes_cubit.dart';

class RoutesState extends Equatable {
  final UIState uiState;
  final String? message;
  final List<CollectorRoutesEntityResponse>? routes;

  const RoutesState(
      {this.message, this.uiState = UIState.initial, this.routes});

  @override
  List<Object?> get props => [uiState, message, routes];

  RoutesState copyWith(
      {UIState? uiState,
      String? message,
      List<CollectorRoutesEntityResponse>? routes      }) {
    return RoutesState(
        uiState: uiState ?? this.uiState,
        message: message ?? this.message,
        routes: routes ?? this.routes,
        );
  }
}

/*class RoutesInitial extends RoutesState {
  @override
  List<Object> get props => [];
}*/
