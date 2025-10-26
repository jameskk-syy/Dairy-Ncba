import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InactivityService {
  Timer? _timer;
  final Duration _timeoutDuration = const Duration(minutes: 30); // Set your timeout duration
  final VoidCallback onTimeoutCallback;

  InactivityService({required this.onTimeoutCallback});

  void startTimer() {
    _timer = Timer(_timeoutDuration, _onTimeout);
    debugPrint('💡 InactivityService: Timer started for $_timeoutDuration');
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
    debugPrint('💡 InactivityService: Timer reset');
  }

  void dispose() {
    _timer?.cancel();
    debugPrint('💡 InactivityService: Timer disposed');
  }

  void _onTimeout() {
    debugPrint('💡 InactivityService: Timer expired');
    // Call the callback when the timer expires
    onTimeoutCallback();
  }
}
