import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

class WeightNotifier extends ChangeNotifier {
  final int stabilityThreshold;
  String _weight = '0.0';
  bool _isStable = false;
  Uint8List _data = Uint8List(0);
  Timer? _stabilityTimer;

  WeightNotifier(this.stabilityThreshold);

  String get weight => _weight;
  bool get isStable => _isStable;
  Uint8List get data => _data;

  void updateWeight(String rawData) {
    print("the data extracted is $rawData");
    List<String> parts = rawData.split(RegExp(r'[^0-9.]+'));
    String? validWeight;
    for (String part in parts.reversed) {
      if (part.isNotEmpty && double.tryParse(part) != null) {
        validWeight = part;
        break;
      }
    }

    if (validWeight != null) {
      double parsedWeight = double.parse(validWeight);
      String newWeight = parsedWeight.toStringAsFixed(1);
      if (_weight != newWeight) {
        _weight = newWeight;
        _isStable = false;
        _resetStabilityTimer();
      }
    } else {
      _weight = '0.0';
      _isStable = false;
    }
    notifyListeners();
  }

  void _resetStabilityTimer() {
    _stabilityTimer?.cancel();
    _stabilityTimer = Timer(Duration(seconds: stabilityThreshold), () {
      _isStable = true;
      notifyListeners();
    });
  }

  void appendData(Uint8List newData) {
    _data = Uint8List.fromList([..._data, ...newData]);
    updateWeight(String.fromCharCodes(_data));
  }

  @override
  void dispose() {
    _stabilityTimer?.cancel();
    super.dispose();
  }
}
