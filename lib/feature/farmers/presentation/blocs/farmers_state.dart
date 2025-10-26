part of 'farmers_cubit.dart';

class FarmersState extends Equatable {
  final String? exception;
  final UIState uiState;
  final bool searching;
  final List<FarmersEntityModel>? farmersResponseModel;
  final List<FarmersEntityModel>? filteredFarmers;
  const FarmersState({this.searching = false, this.exception, this.uiState = UIState.initial, this.farmersResponseModel, this.filteredFarmers});

  @override
  List<Object?> get props => [uiState, farmersResponseModel, exception, filteredFarmers];

  FarmersState copyWith({
    String? exception,
    UIState? uiState,
    List<FarmersEntityModel>? farmersResponseModel,
    List<FarmersEntityModel>? filteredFarmers,
    bool? searching,
  }) {
    return FarmersState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      farmersResponseModel: farmersResponseModel ?? this.farmersResponseModel,
      filteredFarmers: filteredFarmers ?? this.filteredFarmers,
      searching: searching ?? this.searching
    );
  }

}


