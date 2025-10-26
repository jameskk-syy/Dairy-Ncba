part of 'today_collection_cubit.dart';

class TodayCollectionState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CollectionHistoryModel? collectionHistoryModel;
  final CustomResponse? deliveryReturnResponse;
  const TodayCollectionState(
      {this.uiState = UIState.initial,
      this.collectionHistoryModel,
      this.deliveryReturnResponse,
      this.exception});

  @override
  List<Object?> get props => [uiState, collectionHistoryModel, deliveryReturnResponse,exception];

  TodayCollectionState copyWith({
    String? exception,
    UIState? uiState,
    CollectionHistoryModel? collectionHistoryModel,
    CustomResponse? deliveryReturnResponse
  }) {
    return TodayCollectionState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      deliveryReturnResponse: deliveryReturnResponse ?? this.deliveryReturnResponse,
      collectionHistoryModel:
          collectionHistoryModel ?? this.collectionHistoryModel,
    );
  }
}
