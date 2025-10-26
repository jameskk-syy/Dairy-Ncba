part of 'filter_collections_cubit.dart';

 class FilterCollectionsState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CollectionHistoryModel? collectionHistoryModel;
  const FilterCollectionsState({this.uiState = UIState.initial, this.collectionHistoryModel, this.exception});

  @override
  List<Object?> get props => [uiState, collectionHistoryModel, exception];

  FilterCollectionsState copyWith({
    String? exception,
    UIState? uiState,
    CollectionHistoryModel? collectionHistoryModel,
  }) {
    return FilterCollectionsState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      collectionHistoryModel: collectionHistoryModel ?? this.collectionHistoryModel,
    );
  }
}


