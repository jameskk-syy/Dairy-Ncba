part of 'pending_collections_cubit.dart';

class PendingCollectionsState extends Equatable {
  final List<CollectionsEntity>? collections;
  final String? exception;
  final UIState uiState;

  const PendingCollectionsState({this.uiState = UIState.initial, this.exception, this.collections});

  @override
  List<Object?> get props => [uiState, exception, collections];

  PendingCollectionsState copyWith({
    List<CollectionsEntity>? collections,
    String? exception,
    UIState? uiState,
  }) {
    return PendingCollectionsState(
        collections: collections ?? this.collections,
        exception: exception ?? this.exception,
        uiState: uiState ?? this.uiState);
  }
}
