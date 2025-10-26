import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:dairytenantapp/config/theme/colors.dart';
import 'package:dairytenantapp/core/presentation/widgets/dialogs/snackbars.dart';
import 'package:dairytenantapp/core/utils/bluetooth_scale/bt_manager.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

import '../../../../main.dart';
import '../notifiers/quality_notifier.dart';
import 'c_widgets.dart';

class MyDevice {
  static const disconnected = 0;
  static const connected = 1;

  final String name;
  final String address;

  MyDevice(this.name, this.address);
}

class QualityPage extends StatefulWidget {
  const QualityPage({super.key});

  @override
  State<QualityPage> createState() => _QualityPageState();
}

class _QualityPageState extends State<QualityPage> {
  late StreamSubscription deviceStatusSubscription;
  late StreamSubscription deviceDataSubscription;
  late Stream deviceStatusStream;
  late Stream deviceDataStream;
  String platFormVersion = 'Unknown';
  List<MyDevice> devices = [];
  List<MyDevice> _discoveredDevices = [];
  bool _scanning = false;
  int deviceStatus = MyDevice.disconnected;
  String _deviceName = '';
  String _stableWeight = '';
  final logger = Logger();
  late QCNotifier qcNotifier;

  @override
  void initState() {
    super.initState();
    qcNotifier = QCNotifier(); // Initialize QCNotifier
    initPlatformState();

    // Convert the streams to broadcast streams
    deviceStatusStream =
        BluetoothStreamManager().deviceStatusStream.asBroadcastStream();
    deviceDataStream =
        BluetoothStreamManager().deviceDataStream.asBroadcastStream();

    // Subscribe to the broadcast streams
    deviceStatusSubscription = deviceStatusStream.listen((event) {
      if (mounted) {
        setState(() {
          deviceStatus = (event == 2 ? 1 : event);
        });
      }
    });

    deviceDataSubscription = deviceDataStream.listen((event) {
      qcNotifier.updateQCData(event);
    });
  }

  @override
  void dispose() {
    deviceStatusSubscription.cancel();
    deviceDataSubscription.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      if (!mounted) return;
      platformVersion =
          await bluetoothClassicPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      platFormVersion = platformVersion;
    });
  }

  Future<void> _getDevices() async {
    var res = await bluetoothClassicPlugin.getPairedDevices();
    if (mounted) {
      setState(() {
        devices =
            res
                .map((device) => MyDevice(device.name ?? '', device.address))
                .toList();
      });
    }
  }

  Future<void> _scan() async {
    await getPermission();

    if (_scanning) {
      await bluetoothClassicPlugin.stopScan();
      if (mounted) {
        setState(() {
          _scanning = false;
        });
      }
    } else {
      await bluetoothClassicPlugin.startScan();
      bluetoothClassicPlugin.onDeviceDiscovered().listen((event) {
        if (mounted) {
          setState(() {
            _discoveredDevices = [
              ..._discoveredDevices,
              MyDevice(event.name ?? '', event.address),
            ];
          });
        }
      });
      if (mounted) {
        setState(() {
          _stableWeight = qcNotifier.ph.toString(); // Example of using ph value
        });
      }
    }
  }

  Future<void> getPermission() async {
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => qcNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Milk Quality Check'),
          backgroundColor: AppColors.fadeTeal,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Center(
                  child: Consumer<QCNotifier>(
                    builder: (context, notifier, child) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            milkPropertiesWidget(
                              'Temperature',
                              notifier.temperature.toString(),
                            ),
                            milkPropertiesWidget(
                              'Density',
                              notifier.density.toString(),
                            ),
                            milkPropertiesWidget('pH', notifier.ph.toString()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Consumer<QCNotifier>(
                //   builder: (context, notifier, child) {
                //     return Row(
                //       children: [
                //         const Text(
                //           'Stable: ',
                //           style: TextStyle(fontSize: 16),
                //         ),
                //         Icon(
                //           notifier.temperature > 30 // Example condition
                //               ? Icons.check_circle
                //               : Icons.cancel,
                //           color: notifier.temperature > 30 ? Colors.green : Colors.red,
                //           size: 26,
                //         ),
                //         const SizedBox(width: 5),
                //       ],
                //     );
                //   },
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Device Name: $_deviceName',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      'Status: $deviceStatus',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(backgroundColor: AppColors.fadeTeal),
                //       onPressed: qcNotifier.temperature > 30 ? _confirmWeight : null,
                //       child: const Text(
                //         'Confirm Weight',
                //         style: TextStyle(),
                //       ),
                //     ),
                //     const Spacer(),
                //     Text(
                //       'Stable: $_stableWeight KG',
                //       style: const TextStyle(fontSize: 18),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 4),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                      ),
                      onPressed: () {
                        if (_stableWeight.isEmpty) {
                          showSnackbar(context, "Weight is required");
                        } else {
                          Navigator.pop(context, double.parse(_stableWeight));
                        }
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.fadeTeal,
                        ),
                        onPressed: () async {
                          await bluetoothClassicPlugin.initPermissions();
                        },
                        child: const Text(
                          "Check Permissions",
                          style: TextStyle(color: AppColors.black),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.fadeTeal,
                        ),
                        onPressed: () {
                          _getDevices();
                        },
                        child: const Text(
                          "Get Paired Devices",
                          style: TextStyle(color: AppColors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (devices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paired Devices:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      ...devices.map(
                        (device) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(device.name),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextButton(
                                onPressed: () async {
                                  await bluetoothClassicPlugin.connect(
                                    device.address,
                                    "00001101-0000-1000-8000-00805f9b34fb",
                                  );
                                  setState(() {
                                    _discoveredDevices = [];
                                    devices = [];
                                    _deviceName = device.name;
                                  });
                                },
                                child: const Text("Connect"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _scan,
                  child: Text(_scanning ? "Stop Scan" : "Start Scan"),
                ),
                const SizedBox(height: 20),
                if (_discoveredDevices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discovered Devices:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      ..._discoveredDevices.map(
                        (device) => Row(
                          children: [
                            Text(
                              device.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextButton(
                                onPressed: () async {
                                  await bluetoothClassicPlugin.connect(
                                    device.address,
                                    "00001101-0000-1000-8000-00805f9b34fb",
                                  );
                                  setState(() {
                                    _discoveredDevices = [];
                                    devices = [];
                                    _deviceName = device.name;
                                  });
                                },
                                child: const Text("Connect"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
