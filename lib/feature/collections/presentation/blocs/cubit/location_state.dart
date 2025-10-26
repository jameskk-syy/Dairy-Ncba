part of 'location_cubit.dart';

class LocationState {
  final Position? position;
  final String? address;
  final String? errorMessage;

  LocationState({
    this.position,
    this.address,
    this.errorMessage,
  });

  LocationState copyWith({
    Position? position,
    String? address,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocationState(
      position: position ?? this.position,
      address: address ?? this.address,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
