part of 'collections_cubit.dart';

class CollectionsState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CollectionHistoryModel? collectionHistoryModel;
  //final FarmerDetailsModel? farmerDetailsModel;
  const CollectionsState({this.exception, this.uiState = UIState.initial, this.collectionHistoryModel,}); //this.farmerDetailsModel});

  @override
  List<Object?> get props => [uiState, collectionHistoryModel, exception];

  CollectionsState copyWith({
    String? exception,
    UIState? uiState,
    CollectionHistoryModel? collectionHistoryModel,
    FarmerDetailsModel? farmerDetailsModel
  }) {
    return CollectionsState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      collectionHistoryModel: collectionHistoryModel ?? this.collectionHistoryModel,
      //farmerDetailsModel: farmerDetailsModel ?? this.farmerDetailsModel,
    );
  }
}


