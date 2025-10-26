
part of 'collector_daily_cubit.dart';

class CollectorDailyState extends Equatable {
  final String? exception;
  final UIState? uiState;
  final CollectionTotalsModel? collectionTotalsModel;

  const CollectorDailyState(
      {this.exception,
      this.uiState = UIState.initial,
      this.collectionTotalsModel});

  @override
  List<Object?> get props => [exception, uiState, collectionTotalsModel];

  CollectorDailyState copyWith(
      {String? exception,
      UIState? uiState,
      CollectionTotalsModel? collectionTotalsModel}) {
    return CollectorDailyState(
      exception: exception ?? this.exception,
      uiState: uiState ?? this.uiState,
      collectionTotalsModel: collectionTotalsModel ?? this.collectionTotalsModel
    );
  }
}
