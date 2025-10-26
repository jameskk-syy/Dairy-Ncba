part of 'cummulator_stats_cubit.dart';

class CummulatorStatsState extends Equatable {
  final String? exception;
  final UIState uiState;
  final int routes;
  final double totalMilk;
  final int collections;
  final List<TotalsCollectionHistoryEntity>? collectionsList;
  const CummulatorStatsState({this.collectionsList, this.routes = 0, this.uiState = UIState.initial, this.exception, this.totalMilk = 0, this.collections = 0});

  @override
  List<Object?> get props {
    return [routes, uiState, exception, totalMilk, collections, collectionsList];
  }

  CummulatorStatsState copyWith({
    int? routes,
    UIState? uiState,
    String? exception,
    double? totalMilk,
    int? collections,
    List<TotalsCollectionHistoryEntity>? collectionsList,
  }) {
    return CummulatorStatsState(
      routes: routes ?? this.routes,
      uiState: uiState ?? this.uiState,
      exception: exception ?? this.exception,
      totalMilk: totalMilk ?? this.totalMilk,
      collections: collections ?? this.collections,
      collectionsList: collectionsList ?? this.collectionsList,
    );
  }
}


