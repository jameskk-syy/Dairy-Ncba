import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/injector_container.dart';
import '../utils/services/autologout.dart';

class InactivityWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTimeout;

  const InactivityWidget(
      {super.key, required this.child, required this.onTimeout});

  @override
  State<InactivityWidget> createState() => _InactivityWidgetState();
}

class _InactivityWidgetState extends State<InactivityWidget>
    with WidgetsBindingObserver {
  InactivityService? _inactivityService;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startInactivityService();
    loadLoginState();
    debugPrint('💡 InactivityWidget: initState called, timer started');
  }

void loadLoginState() async {
  // Introduce a delay of 7 seconds
  await Future.delayed(const Duration(seconds: 15));

  SharedPreferences sharedPrefs = sl<SharedPreferences>();
  setState(() {
    isLoggedIn = sharedPrefs.getBool('isLoggedIn') ?? false;
  });

  // Start or stop the timer based on login status
  if (isLoggedIn) {
    _startInactivityService();
    debugPrint('💡 AuthService: Login successful, timer started!');
  } else {
    debugPrint('💡 AuthService: Not logged in, timer stopped.');
  }
}


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityService?.dispose();
    debugPrint('💡 InactivityWidget: dispose called, timer disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _inactivityService?.dispose();
      debugPrint('💡 InactivityWidget: App paused, timer disposed');
    } else if (state == AppLifecycleState.resumed) {
      _startInactivityService();
      debugPrint('💡 InactivityWidget: App resumed, timer started');
    }
  }

  void _resetTimer() {
    _inactivityService?.resetTimer();
    debugPrint('💡 InactivityWidget: resetTimer called');
  }

  void _startInactivityService() {
    _inactivityService = InactivityService(onTimeoutCallback: widget.onTimeout);
    _inactivityService?.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      onDoubleTap: _resetTimer,
      onDoubleTapDown: (details) => _resetTimer,
      onPanDown: (details) => _resetTimer(),
      onPanUpdate: (details) => _resetTimer(),
      child: widget.child,
    );
  }
}
