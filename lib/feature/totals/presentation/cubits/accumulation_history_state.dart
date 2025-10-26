part of 'accumulation_history_cubit.dart';

class AccumulationHistoryState extends Equatable {
  final String? exception;
  final UIState uiState;
  final List<TotalsCollectionHistoryEntity> data;
  const AccumulationHistoryState({this.data = const [], this.uiState = UIState.initial, this.exception});

  @override
  List<Object?> get props {
    return [data, uiState, exception];
  }

  AccumulationHistoryState copyWith({
    List<TotalsCollectionHistoryEntity>? data,
    UIState? uiState,
    String? exception,
  }) {
    return AccumulationHistoryState(
      data: data ?? this.data,
      uiState: uiState ?? this.uiState,
      exception: exception ?? this.exception,
    );
  }
}


