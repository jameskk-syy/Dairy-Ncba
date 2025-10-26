import 'dart:async';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/services.dart';

class BluetoothStreamManager {
  static final BluetoothStreamManager _instance =
      BluetoothStreamManager._internal();

  factory BluetoothStreamManager() {
    return _instance;
  }

  BluetoothStreamManager._internal();

  // Broadcast stream controllers to allow multiple listeners
  final StreamController<int> _deviceStatusController =
      StreamController<int>.broadcast();
  final StreamController<Uint8List> _deviceDataController =
      StreamController<Uint8List>.broadcast();

  // Public streams
  Stream<int> get deviceStatusStream => _deviceStatusController.stream;
  Stream<Uint8List> get deviceDataStream => _deviceDataController.stream;

  // Initialize with the plugin
  void initialize(BluetoothClassic plugin) {
    plugin.onDeviceStatusChanged().listen((event) {
      _deviceStatusController.add(event);
    });

    plugin.onDeviceDataReceived().listen((event) {
    Uint8List eventData = Uint8List.fromList(event);
    _deviceDataController.add(eventData);
      });
  }
}
