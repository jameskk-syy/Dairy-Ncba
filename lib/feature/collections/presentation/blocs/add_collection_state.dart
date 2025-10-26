part of 'add_collection_cubit.dart';

class AddCollectionState extends Equatable {
  final String? exception;
  final UIState uiState;
  final CollectionResponse? collectionResponse;
  final File? receipt;
  const AddCollectionState(
      {this.exception,
      this.uiState = UIState.initial,
      this.collectionResponse,
      this.receipt
      });

  @override
  List<Object?> get props => [exception, uiState, collectionResponse, receipt];

  AddCollectionState copyWith({
    String? exception,
    UIState? uiState,
    CollectionResponse? collectionResponse,
    File? receipt
  }) {
    return AddCollectionState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      collectionResponse: collectionResponse ?? this.collectionResponse,
      receipt: receipt ?? this.receipt
    );
  }
}
