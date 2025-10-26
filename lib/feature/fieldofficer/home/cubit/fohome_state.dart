// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'fohome_cubit.dart';

class FohomeState extends Equatable {
  final String? exception;
  final UIState? uiState;
  final bool? searching;
  final List<FarmersEntityModel>? farmersResponseModel;
  final List<FarmersEntityModel>? filteredFarmers;
  final List<Delivery>? deliveries;
  final File? statement;
  final File? allocationReport;
  final File? routeReport;
  const FohomeState(
      {this.exception,
      this.uiState,
      this.searching,
      this.farmersResponseModel,
      this.deliveries,
      this.statement,
      this.filteredFarmers,
      this.allocationReport,
      this.routeReport});

  @override
  List<Object?> get props => [
        uiState,
        farmersResponseModel,
        exception,
        filteredFarmers,
        deliveries,
        statement,
        allocationReport,
        routeReport
      ];

  FohomeState copyWith(
      {String? exception,
      UIState? uiState,
      bool? searching,
      List<FarmersEntityModel>? farmersResponseModel,
      List<FarmersEntityModel>? filteredFarmers,
      List<Delivery>? deliveries,
      File? statement,
      File? allocationReport,
      File? routeReport}) {
    return FohomeState(
        exception: exception ?? this.exception,
        uiState: uiState ?? this.uiState,
        searching: searching ?? this.searching,
        farmersResponseModel: farmersResponseModel ?? this.farmersResponseModel,
        filteredFarmers: filteredFarmers ?? this.filteredFarmers,
        deliveries: deliveries ?? this.deliveries,
        statement: statement ?? this.statement,
        allocationReport: allocationReport ?? this.allocationReport,
        routeReport: routeReport ?? this.routeReport);
  }
}

class FohomeInitial extends FohomeState {}
