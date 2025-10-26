import 'package:equatable/equatable.dart';

class AddCollectionDto extends Equatable {
  final int collectorId;
  final int routeId;
  final int farmerNumber;
  final double quantity;
  final String session;
  final String? latitude;
  final String? longitude;
  final String event;
  final String status;
  final String updatedStatus;
  final String paymentStatus;
  final String collectionDate;

  const AddCollectionDto(
      {required this.collectorId,
      required this.routeId,
      required this.farmerNumber,
      required this.quantity,
      required this.session,
      //required this.canNumber,
      this.latitude,
      this.longitude,
      required this.event,
      required this.status,
      required this.updatedStatus,
      required this.paymentStatus,
      required this.collectionDate});

  @override
  List<Object?> get props {
    return [
      collectorId,
      routeId,
      farmerNumber,
      quantity,
      session,
      // canNumber,
      latitude,
      longitude,
      event,
      status,
      updatedStatus,
      paymentStatus,
      collectionDate
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'collectorId': collectorId,
      'routeFk': routeId,
      'farmerNo': farmerNumber,
      'quantity': quantity,
      'session': session,
      //'canNo': canNumber,
      'latitude': latitude,
      'longitude': longitude,
      'event': event,
      'status': status,
      'updatedStatus': updatedStatus,
      'paymentStatus': paymentStatus,
      'collectionDate': collectionDate
    };
  }

//To Json
/*Map<String, dynamic> toJson() => {
        "collectorId": collectorId,
        "routeFk": routeId,
        "farmerNo": farmerNumber,
        "originalQuantity": quantity,
        "session": session,
        "canNo": canNumber,
        "latitude": latitude,
        "longitude": longitude,
        "event": event,
      };*/
}
