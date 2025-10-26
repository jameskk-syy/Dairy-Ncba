part of 'farmer_details_cubit.dart';

class FarmerDetailsCubitState extends Equatable {
  final FarmerDetailsEntityModel? farmerDetailsModel;
  final String? exception;
  final UIState uiState;
  const FarmerDetailsCubitState({this.exception, this.uiState = UIState.initial, this.farmerDetailsModel});

  @override
  List<Object?> get props => [exception, uiState, farmerDetailsModel];

  FarmerDetailsCubitState copyWith({
    String? exception,
    FarmerDetailsEntityModel? farmerDetailsModel,
     UIState? uiState,
  }) {
    return FarmerDetailsCubitState(
      exception : exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      farmerDetailsModel: farmerDetailsModel ?? this.farmerDetailsModel,
    );
  }
}



