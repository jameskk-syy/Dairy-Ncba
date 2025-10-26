abstract class FarmersEvent {}

class FetchFarmers extends FarmersEvent {
  final int collectorId;

  FetchFarmers(this.collectorId);
}

class SearchFarmers extends FarmersEvent {
  final String query;

  SearchFarmers(this.query);
}
