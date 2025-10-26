import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState());

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(
      // loading: true, 
    errorMessage: null));

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(
          // loading: false,
          errorMessage: 'Location services are disabled. Please enable them.',
        ));
        return;
      }

      // Check location permissions
      final permissionStatus = await Geolocator.checkPermission();
      if (permissionStatus == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if (requestPermission != LocationPermission.whileInUse &&
            requestPermission != LocationPermission.always) {
          emit(state.copyWith(
            // loading: false,
            errorMessage: 'Location permission denied.',
          ));
          return;
        }
      } else if (permissionStatus == LocationPermission.deniedForever) {
        emit(state.copyWith(
          // loading: false,
          errorMessage: 'Location permissions are permanently denied. Please enable them in settings.',
        ));
        return;
      }

      // Get the current position with a timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location request timed out. Please try again.');
        },
      );

      // Reverse geocoding
      final geocodingPlatform = GeocodingPlatform.instance;
      if (geocodingPlatform != null) {
        final addresses = await geocodingPlatform.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        // Extract address
        final address = addresses.isNotEmpty ? addresses[0].administrativeArea : null;

        emit(state.copyWith(
          position: position,
          address: address,
          // loading: false,
        ));
      } else {
        emit(state.copyWith(
          // loading: false,
          errorMessage: 'Geocoding platform is not initialized.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        // loading: false,
        errorMessage: 'Failed to get current location: $e',
      ));
    }
  }
}
