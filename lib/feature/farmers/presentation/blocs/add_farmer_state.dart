part of 'add_farmer_cubit.dart';

class AddFarmerState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CountiesResponseModel? countiesResponseModel;
  final SubCountiesResponseModel? subCountiesResponseModel;
  final PickupLocationModel? pickupLocationModel;
  final RoutesResponseModel? routesResponseModel;
  final CustomResponse? customResponse;
  final OnBoardFarmerResponseModel? onBoardFarmerResponseModel;
  final OnBoardFarmerResponseDto? onBoardFarmerResponseDto;

  const AddFarmerState(
      {this.uiState = UIState.initial,
      this.exception,
      this.countiesResponseModel,
      this.subCountiesResponseModel,
      this.pickupLocationModel,
      this.routesResponseModel,
      this.onBoardFarmerResponseModel,
      this.onBoardFarmerResponseDto,
      this.customResponse});

  @override
  List<Object?> get props => [
        uiState,
        exception,
        countiesResponseModel,
        subCountiesResponseModel,
        pickupLocationModel,
        routesResponseModel,
        onBoardFarmerResponseModel,
        onBoardFarmerResponseDto,
        customResponse
      ];

  AddFarmerState copyWith(
      {String? exception,
      UIState? uiState,
      CountiesResponseModel? countiesResponseModel,
      SubCountiesResponseModel? subCountiesResponseModel,
      PickupLocationModel? pickupLocationModel,
      RoutesResponseModel? routesResponseModel,
      OnBoardFarmerResponseModel? onBoardFarmerResponseModel,
      OnBoardFarmerResponseDto? onBoardFarmerResponseDto,
      CustomResponse? customResponse}) {
    return AddFarmerState(
        exception: exception ?? this.exception,
        uiState: uiState ?? this.uiState,
        countiesResponseModel:
            countiesResponseModel ?? this.countiesResponseModel,
        subCountiesResponseModel:
            subCountiesResponseModel ?? this.subCountiesResponseModel,
        pickupLocationModel: pickupLocationModel ?? this.pickupLocationModel,
        routesResponseModel: routesResponseModel ?? this.routesResponseModel,
        onBoardFarmerResponseModel:
            onBoardFarmerResponseModel ?? this.onBoardFarmerResponseModel,
        onBoardFarmerResponseDto:
            onBoardFarmerResponseDto ?? this.onBoardFarmerResponseDto,
        customResponse: customResponse ?? this.customResponse);
  }
}
