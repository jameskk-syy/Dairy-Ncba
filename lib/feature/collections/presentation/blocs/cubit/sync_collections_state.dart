part of 'sync_collections_cubit.dart';

class SyncCollectionsState extends Equatable {
  final UIState uiState;
  final String? exception;
  final String? message;
  final List<CollectionsEntity> collections;
  const SyncCollectionsState({this.uiState = UIState.initial, this.exception, this.message, this.collections = const []});

  @override
  List<Object?> get props {
    return [uiState, exception, message, collections];
  }

  SyncCollectionsState copyWith({
    UIState? uiState,
    String? exception,
    String? message,
    List<CollectionsEntity>? collections,
  }) {
    return SyncCollectionsState(
      uiState: uiState ?? this.uiState,
      exception: exception ?? this.exception,
      message: message ?? this.message,
      collections: collections ?? this.collections,
    );
  }
}


