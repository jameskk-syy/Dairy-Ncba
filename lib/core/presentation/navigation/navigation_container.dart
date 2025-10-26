import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../feature/collections/presentation/pages/today_collections_history_page.dart';
import '../../../../feature/farmers/presentation/pages/farmers_page.dart';
import '../../../../feature/fieldofficer/farmers/ui/home.dart';
import '../../../../feature/fieldofficer/home/ui/fo_home.dart';
import '../../../../feature/fieldofficer/inventory/ui/inventory_home.dart';
import '../../../../feature/fieldofficer/mccs/ui/mcc.dart';
import '../../../../feature/home/presentation/cubit/home_cubit.dart';
import '../../../../feature/totals/presentation/pages/products/requests.dart';
import '../../../config/theme/colors.dart';
import '../../../feature/auth/presentation/pages/login_page.dart';
import '../../../feature/home/presentation/page/home_page.dart';
import '../../../feature/profile/presentation/pages/profile_page.dart';
import '../../../feature/sales/presentation/pages/sales_page.dart';
import '../../../feature/totals/presentation/pages/totals_collections_page.dart';
import '../../../feature/totals/presentation/pages/totals_collector_page.dart';
import '../../../feature/transporter/pages/trans_requests.dart';
import '../../data/dto/login_response_dto.dart';
import '../../di/injector_container.dart';
import '../../utils/services/autologout.dart';
import '../../utils/user_data.dart';

class BottomNavigationContainer extends StatefulWidget {
  final int index;
  const BottomNavigationContainer({super.key, this.index = 0});

  @override
  State<BottomNavigationContainer> createState() =>
      _BottomNavigationContainerState();
}

class _BottomNavigationContainerState extends State<BottomNavigationContainer>
    with WidgetsBindingObserver {
  int currentIndex = 0;
  String? role;
  String? foRole;
  InactivityService? _inactivityService;
  late bool isLoggedIn = false;
  late BuildContext scaffoldContext;

  List<Widget> _screens = <Widget>[
    TodaysCollectionsPage(),
    const HomePage(),
    const Requests(),
    const FarmersPage(),
  ];

  void _updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    WidgetsBinding.instance.addObserver(this);
    startInactivityService(context);
    loadLoginState();
    fetchUserRole();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Fetch and set user role dynamically based on saved login data
  void fetchUserRole() {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");

    if (userData == null || userData.isEmpty) {
      print("⚠️ No user data found in SharedPreferences.");
      return;
    }

    final user = LoginResponseDto.fromJson(jsonDecode(userData));

    // ✅ Safely check if roles are null or empty
    if (user.roles == null || user.roles!.isEmpty) {
      print("⚠️ No roles found for this user.");
      setState(() {
        role = "MILK_COLLECTOR"; // Default fallback role
      });
      return;
    }

    // Extract first role safely
    final roles = user.roles!.map((e) => e.name).toList();
    final roleFromApi = roles.first;
    foRole = roleFromApi;

    print("✅ User role detected: $foRole");

    /// Update screens and state based on role
    setState(() {
      if (roleFromApi == "SALES_PERSON") {
        role = "SALES_PERSON";
        _screens[1] = const SalesPage();
      } else if (roleFromApi == "TOTALS_COLLECTOR") {
        role = "TOTALS_COLLECTOR";
        _screens = [
          const TotalsCollectorHomePage(),
          const TotalsCollectionsHistory(),
          const Requests(),
          const FarmersPage(),
        ];
      } else if (roleFromApi == "FIELD_OFFICER") {
        role = "FIELD_OFFICER";
        _screens = const [
          FOHomePage(),
          MccPage(),
          InventoryHome(),
          AllFarmers(),
        ];
      } else if (roleFromApi == "TRANSPORTER") {
        role = "TRANSPORTER";
        _screens = [
          TodaysCollectionsPage(),
          const HomePage(),
          const TransporterRequests(),
          const FarmersPage(),
        ];
      } else {
        role = "MILK_COLLECTOR"; // Default role
        if (!_screens.contains(const ProfilePage())) {
          _screens.add(const ProfilePage());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..getMyRoutes(getUserData().id!),
      child: Scaffold(
        body: Builder(builder: (context) {
          scaffoldContext = context;
          return _screens[currentIndex];
        }),
        bottomNavigationBar: NavigationBar(
          surfaceTintColor: isDarkMode
              ? AppColors.darkColorScheme.onSurface
              : AppColors.lightColorScheme.onSurface,
          indicatorColor: AppColors.fadeTeal,
          selectedIndex: currentIndex,
          animationDuration: const Duration(milliseconds: 200),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: _updateIndex,
          destinations: _buildNavigationDestinations(),
        ),
      ),
    );
  }

  /// Build bottom navigation tabs dynamically based on role
  List<Widget> _buildNavigationDestinations() {
    final List<Widget> navigationDestinations = [];

    if (role == "SALES_PERSON") {
      navigationDestinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          selectedIcon: Icon(Icons.home_filled),
        ),
        const NavigationDestination(
          icon: Icon(Icons.energy_savings_leaf_outlined),
          label: 'Sales',
          selectedIcon: Icon(Icons.energy_savings_leaf_sharp),
        ),
        const NavigationDestination(
          icon: Icon(Icons.trending_down_sharp),
          label: 'Collections',
          selectedIcon: Icon(Icons.trending_down_sharp),
        ),
      ]);
    } else if (role == "MILK_COLLECTOR") {
      navigationDestinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.trending_down_sharp),
          label: 'Collections',
          selectedIcon: Icon(Icons.trending_down_sharp),
        ),
        const NavigationDestination(
          icon: Icon(Icons.query_stats_outlined),
          label: 'Home',
          selectedIcon: Icon(Icons.home_filled),
        ),
        const NavigationDestination(
          icon: Icon(Icons.inventory),
          label: "Requests",
        ),
        const NavigationDestination(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Farmers',
          selectedIcon: Icon(Icons.people),
        ),
      ]);
    } else if (foRole == "FIELD_OFFICER") {
      navigationDestinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: "Home",
          selectedIcon: Icon(Icons.home_filled),
        ),
        const NavigationDestination(
          icon: Icon(Icons.route_outlined),
          label: "MCC",
          selectedIcon: Icon(Icons.route_rounded),
        ),
        const NavigationDestination(
          icon: Icon(Icons.inventory_2),
          label: "Inventory",
          selectedIcon: Icon(Icons.inventory_2_outlined),
        ),
        const NavigationDestination(
          icon: Icon(Icons.people_sharp),
          label: "Farmers",
          selectedIcon: Icon(Icons.people_rounded),
        ),
      ]);
    } else if (foRole == "TRANSPORTER") {
      navigationDestinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.trending_down_sharp),
          label: 'Collections',
          selectedIcon: Icon(Icons.trending_down_sharp),
        ),
        const NavigationDestination(
          icon: Icon(Icons.query_stats_outlined),
          label: 'Home',
          selectedIcon: Icon(Icons.home_filled),
        ),
        const NavigationDestination(
          icon: Icon(Icons.inventory),
          label: "Requests",
        ),
        const NavigationDestination(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Farmers',
          selectedIcon: Icon(Icons.people),
        ),
      ]);
    } else {
      navigationDestinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          selectedIcon: Icon(Icons.home_filled),
        ),
        const NavigationDestination(
          icon: Icon(Icons.trending_down_sharp),
          label: 'Collections',
          selectedIcon: Icon(Icons.trending_down_sharp),
        ),
      ]);
    }

    return navigationDestinations;
  }

  /// Load login state and manage inactivity timer
  void loadLoginState() async {
    final Logger logger = Logger();
    logger.i("Initial delay after login before starting timer");

    await Future.delayed(const Duration(seconds: 10));
    if (!mounted) return;

    SharedPreferences sharedPrefs = sl<SharedPreferences>();
    setState(() {
      isLoggedIn = sharedPrefs.getBool('isLoggedIn') ?? false;
    });

    if (isLoggedIn) {
      _inactivityService?.startTimer();
      logger.i("Started timer after login");
      debugPrint('💡 AuthService: Login successful, timer started!');
    } else {
      debugPrint('💡 AuthService: Not logged in, timer stopped.');
    }
  }

  /// Start inactivity timer
  void startInactivityService(BuildContext context) {
    _inactivityService?.startTimer();
    if (isLoggedIn) {
      _inactivityService =
          InactivityService(onTimeoutCallback: () => handleLogout(context));
    }
  }

  /// Logout and redirect to login page
  void handleLogout(BuildContext context) {
    SharedPreferences sharedPrefs = sl<SharedPreferences>();
    sharedPrefs.setBool("isLoggedIn", false);
    debugPrint('💡 AuthService: Timer expired, logged out');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
