import 'dart:convert';
import 'package:flutter/foundation.dart';

class QCNotifier extends ChangeNotifier {
  double _ph = 0.0;
  double _temperature = 0.0;
  double _density = 0.0;
  String _rawData = '';

  double get ph => _ph;
  double get temperature => _temperature;
  double get density => _density;
  String get rawData => _rawData;

  void updateQCData(String jsonData) {
    try {
      _rawData = jsonData;
      final Map<String, dynamic> parsedData = json.decode(jsonData);

      if (parsedData.containsKey('ph')) {
        _ph = (parsedData['ph'] as num).toDouble();
      }
      if (parsedData.containsKey('temperature')) {
        _temperature = (parsedData['temperature'] as num).toDouble();
      }
      if (parsedData.containsKey('density')) {
        _density = (parsedData['density'] as num).toDouble();
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing JSON data: $e");
      }
    }
  }
}
