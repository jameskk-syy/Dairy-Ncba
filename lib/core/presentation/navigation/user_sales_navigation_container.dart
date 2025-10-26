import 'package:dairytenantapp/feature/collections/presentation/pages/today_collections_history_page.dart';
import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../../feature/home/presentation/page/home_page.dart';
import '../../../feature/sales/presentation/pages/sales_page.dart';

class UserSalesBottomNavigationContainer extends StatefulWidget {
  const UserSalesBottomNavigationContainer({super.key});

  @override
  State<UserSalesBottomNavigationContainer> createState() =>
      _UserSalesBottomNavigationContainerState();
}

class _UserSalesBottomNavigationContainerState
    extends State<UserSalesBottomNavigationContainer> {
  int currentIndex = 0;

  final List<Widget> _screens = <Widget>[
    const HomePage(),
    const SalesPage(),
    TodaysCollectionsPage(),
    //const ProfilePage()
  ];

  void _updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        surfaceTintColor:
            isDarkMode
                ? AppColors.darkColorScheme.onSurface
                : AppColors.lightColorScheme.onSurface,
        selectedIndex: currentIndex,
        animationDuration: const Duration(milliseconds: 200),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _updateIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home_filled),
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Collections',
            selectedIcon: Icon(Icons.people),
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_down_sharp),
            label: 'Sales',
            selectedIcon: Icon(Icons.trending_down_sharp),
          ),
          /*NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
            selectedIcon: Icon(Icons.settings),
          ),*/
        ],
      ),
    );
  }
}
