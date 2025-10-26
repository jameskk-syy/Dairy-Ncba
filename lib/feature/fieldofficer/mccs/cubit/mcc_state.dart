part of 'mcc_cubit.dart';

class MccState extends Equatable {
  final String? exception;
  final UIState? uiState;
  final List<PickupLocationEntityModel>? pickUpLocationModel;
  final List<RoutesEntityModel>? routesList;
  final List<RouteSummaryModel>? routeSummary;
  const MccState(
      {this.uiState,
      this.exception,
      this.pickUpLocationModel,
      this.routeSummary,
      this.routesList});

  @override
  List<Object?> get props =>
      [exception, uiState, pickUpLocationModel, routesList, routeSummary];

  MccState copyWith(
      {String? exception,
      UIState? uiState,
      List<PickupLocationEntityModel>? pickUpLocationModel,
      List<RouteSummaryModel>? routeSummary,
      List<RoutesEntityModel>? routesList}) {
    return MccState(
        exception: exception ?? this.exception,
        uiState: uiState ?? this.uiState,
        pickUpLocationModel: pickUpLocationModel ?? this.pickUpLocationModel,
        routeSummary: routeSummary ?? this.routeSummary,
        routesList: routesList ?? this.routesList);
  }
}
