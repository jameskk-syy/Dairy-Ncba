
part of 'collector_supply_cubit.dart';

class CollectorSupplyState extends Equatable {
  final UIState? uiState;
  final String? exception;
  final CollectionTotalsModel? collectionTotalsModel;

  const CollectorSupplyState(
      {this.uiState = UIState.initial,
      this.exception,
      this.collectionTotalsModel});

  @override
  List<Object?> get props => [uiState, exception, collectionTotalsModel];

  CollectorSupplyState copyWith(
      {UIState? uiState,
      String? exception,
      CollectionTotalsModel? collectionTotalsModel}) {
    return CollectorSupplyState(
      uiState: uiState ?? this.uiState,
      exception: exception ?? this.exception,
      collectionTotalsModel: collectionTotalsModel ?? this.collectionTotalsModel
    );
  }
}
