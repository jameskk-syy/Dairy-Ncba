import 'dart:io';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:dairytenantapp/core/cubits/connection_cubit.dart';
import 'package:dairytenantapp/core/di/injector_container.dart';
import 'package:dairytenantapp/core/utils/bluetooth_scale/bt_manager.dart';
import 'package:dairytenantapp/core/utils/services/httpOverrides.dart';
import 'package:dairytenantapp/splash.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme/colors.dart';
import 'core/cubits/sync_state_cubit.dart';
import 'core/presentation/navigation/navigation_container.dart';
import 'core/widgets/inactivity_widget.dart';
import 'feature/auth/presentation/pages/login_page.dart';
import 'core/di/injector_container.dart' as di;
import 'feature/collections/domain/repository/collections_repository.dart';
import 'feature/collections/presentation/blocs/cubit/pending_collections_cubit.dart';

final BluetoothClassic bluetoothClassicPlugin = BluetoothClassic();
final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  HttpOverrides.global = MyHttpOverrides();
  BluetoothStreamManager().initialize(bluetoothClassicPlugin);
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    loadLoginState();
  }

  void loadLoginState() async {
    SharedPreferences sharedPrefs = sl<SharedPreferences>();
    setState(() {
      isLoggedIn = sharedPrefs.getBool('isLoggedIn') ?? false;
    });
  }

  handleLogout(BuildContext context) {
    SharedPreferences sharedPrefs = sl<SharedPreferences>();
    sharedPrefs.setBool("isLoggedIn", false);
    debugPrint('💡 AuthService: Timer expired, logged out');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final syncDialogCubit = SyncStateCubit(sl<CollectionsRepository>());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<PendingCollectionsCubit>()..getPendingCollections(),
        ),
        BlocProvider(
          create: (context) => sl<ConnectionCubit>()..checkConnection(),
        ),
        BlocProvider.value(value: syncDialogCubit),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: AppColors.lightColorScheme,
        ),
        themeMode: ThemeMode.light,
        home: Builder(
          builder: (context) {
            return InactivityWidget(
              onTimeout: () => handleLogout(context),
              child: FutureBuilder<bool>(
                future: syncDialogCubit.stream.first,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return syncDialog(context);
                  } else {
                    return isLoggedIn
                        ? const BottomNavigationContainer()
                        : const SplashScreen();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget syncDialog(BuildContext context) {
    return BlocBuilder<SyncStateCubit, bool>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Sync Data'),
          content: const Text('Do you want to sync data from the server?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationContainer(),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  await localNotificationsPlugin.initialize(initializationSettings);
}
