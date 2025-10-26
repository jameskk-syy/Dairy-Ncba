// import 'package:dairy_app/core/utils/services/autologout.dart';
// import 'package:flutter/foundation.dart';

// class LoginNotifier extends ChangeNotifier {
//   late InactivityService _inactivityService;
//   bool _isLoggedIn = false;

//   LoginNotifier() {
//     _inactivityService = InactivityService(onTimeoutCallback: _handleLogout);
//   }

//   bool get isLoggedIn => _isLoggedIn;

//   void setLoginStatus(bool loggedIn) {
//     _isLoggedIn = loggedIn;
//     if (_isLoggedIn) {
//       _inactivityService.startTimer();
//       debugPrint('💡 AuthService: Timer started');
//     } else {
//       _inactivityService.dispose();
//       debugPrint('💡 AuthService: Timer stopped');
//     }
//     notifyListeners();
//   }

//   void _handleLogout() {
//     // Handle logout logic here
//     _inactivityService.dispose();
//     debugPrint('💡 AuthService: Timer expired, logged out');
//     // Here you could use a navigator to go back to the login page if needed
//   }
// }
