import 'dart:async';

import '../../../../config/theme/colors.dart';
import '../../../../core/presentation/widgets/dialogs/snackbars.dart';
import '../../../../core/presentation/widgets/fields.dart/input_fields.dart';
import '../../../../core/utils/bluetooth_scale/bt_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../notifiers/change_notifier.dart';

class MyDevice {
  static const disconnected = 0;
  static const connected = 1;

  final String name;
  final String address;

  MyDevice(this.name, this.address);
}

// class WeighPage extends StatefulWidget {
//   const WeighPage({Key? key}) : super(key: key);

//   @override
//   State<WeighPage> createState() => _WeighPageState();
// }

// class _WeighPageState extends State<WeighPage> {
//   late StreamSubscription deviceStatusSubscription;
//   late StreamSubscription deviceDataSubscription;
//   late Stream deviceDataStream;
//   late Stream deviceDataStatusStream;
//   String _platformVersion = 'Unknown';
//   // final _bluetoothClassicPlugin = BluetoothClassic();
//   List<MyDevice> _devices = [];
//   List<MyDevice> _discoveredDevices = [];
//   bool _scanning = false;
//   int _deviceStatus = MyDevice.disconnected;
//   Uint8List _data = Uint8List(0);
//   static bool loading = false;

//   String _weight = '00.00';
//   bool _isStable = false;
//   String _deviceName = '';
//   String _stableWeight = '';
//   Timer? _stabilityTimer;
//   String deviceName = "";
//   static const int stabilityThreshold =
//       3; // Number of seconds to confirm stability

//   final logger = Logger();

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     deviceDataStream =
//         BluetoothStreamManager().deviceDataStream.asBroadcastStream();
//     deviceDataStatusStream =
//         BluetoothStreamManager().deviceStatusStream.asBroadcastStream();
//     deviceStatusSubscription = deviceDataStatusStream.listen((event) {
//       if (mounted) {
//         setState(() {
//           _deviceStatus = (event == 2 ? 1 : event);
//         });
//       }
//     });
//     deviceDataSubscription = deviceDataStream.listen((event) {
//       if (mounted) {
//         setState(() {
//           _data = Uint8List.fromList([..._data, ...event]);
//           // Parse the received data to update the weight value
//           _updateWeight(String.fromCharCodes(_data));
//         });
//       }
//     });
//   }

//   void _updateWeight(String rawData) {
//     // Debug print to see the raw data received
//     // print('Raw data received: $rawData');

//     // Split the raw data based on non-numeric characters
//     List<String> parts = rawData.split(RegExp(r'[^0-9.]+'));
//     // print('Parts after splitting: $parts'); // Debug print

//     // Find the first valid numeric part
//     String? validWeight;
//     for (String part in parts.reversed) {
//       // logger.i('Checking part: $part'); // Debug print
//       if (part.isNotEmpty && double.tryParse(part) != null) {
//         validWeight = part;
//         break;
//       }
//     }

//     // Update weight and stability status based on the extracted part
//     if (validWeight != null) {
//       double parsedWeight = double.parse(validWeight);
//       String newWeight = parsedWeight.toStringAsFixed(1);

//       // If the weight has changed, reset the stability timer
//       if (_weight != newWeight) {
//         _weight = newWeight;
//         _isStable = false;
//         _resetStabilityTimer();
//       }
//     } else {
//       _weight = '0.0';
//       _isStable = false;
//     }

//     // logger.i('Parsed weight: $_weight'); // Debug print
//     // logger.i('Is stable: $_isStable'); // Debug print
//   }

//   void _resetStabilityTimer() {
//     _stabilityTimer?.cancel();
//     _stabilityTimer = Timer(const Duration(seconds: stabilityThreshold), () {
//       if (!mounted) return;
//       if (mounted) {
//         setState(() {
//           _isStable = true;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _stabilityTimer?.cancel();
//     deviceStatusSubscription.cancel();
//     deviceDataSubscription.cancel();
//     super.dispose();
//   }

//   Future<void> initPlatformState() async {
//     String platformVersion;
//     try {
//       platformVersion = await bluetoothClassicPlugin.getPlatformVersion() ??
//           'Unknown platform version';
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

//   Future<void> _getDevices() async {
//     var res = await bluetoothClassicPlugin.getPairedDevices();
//     if (mounted) {
//       setState(() {
//         _devices = res
//             .map((device) => MyDevice(device.name ?? '', device.address))
//             .toList();
//       });
//     }
//   }

//   Future<void> _scan() async {
//     if (_scanning) {
//       await bluetoothClassicPlugin.stopScan();
//       if (mounted) {
//         setState(() {
//           _scanning = false;
//         });
//       }
//     } else {
//       await bluetoothClassicPlugin.startScan();
//       bluetoothClassicPlugin.onDeviceDiscovered().listen(
//         (event) {
//           if (mounted) {
//             setState(() {
//               _discoveredDevices = [
//                 ..._discoveredDevices,
//                 MyDevice(event.name ?? '', event.address)
//               ];
//             });
//           }
//         },
//       );
//       if (mounted) {
//         setState(() {
//           _stableWeight = _weight;
//         });
//       }
//     }
//   }

//   void _confirmWeight() {
//     if (mounted) {
//       setState(() {
//         _stableWeight = _weight;
//       });
//     }
//     // You can use _stableWeight elsewhere in your app
//     logger.i('Stable Weight: $_stableWeight');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.fadeTeal,
//         title: const Text('Weighing Page'),
//         centerTitle: true,
//         // leading: IconButton(
//         //     onPressed: () {
//         //       Navigator.pop(context);
//         //     },
//         //     icon: const Icon(Icons.arrow_back)),
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   // const Text(
//                   //   'Data:',
//                   //   // 'Received data: ${String.fromCharCodes(_data)}',
//                   //   style: TextStyle(fontSize: 16),
//                   // ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             _weight,
//                             style: TextStyle(
//                               fontSize: 48,
//                               color: _isStable ? Colors.green : Colors.red,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Text(
//                             'KG',
//                             style: TextStyle(
//                               fontSize: 24,
//                               color: _isStable ? Colors.green : Colors.red,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       const Text(
//                         'Stable: ',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Icon(
//                         _isStable ? Icons.check_circle : Icons.cancel,
//                         color: _isStable ? Colors.green : Colors.red,
//                         size: 26,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Device Name: $_deviceName',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const Spacer(),
//                       Text(
//                         'Status: $_deviceStatus',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.fadeTeal),
//                         onPressed: _isStable ? _confirmWeight : null,
//                         child: const Text(
//                           'Confirm Weight',
//                           style: TextStyle(),
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         'Stable: $_stableWeight KG',
//                         style: const TextStyle(fontSize: 18),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Center(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width / 1.1,
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.teal),
//                           onPressed: () {
//                             if (_stableWeight.isEmpty) {
//                               showSnackbar(context, "weight is required");
//                             } else {
//                               Navigator.pop(
//                                   context, double.parse(_stableWeight));
//                             }
//                           },
//                           child: const Text(
//                             "Continue",
//                             style: TextStyle(color: Colors.black, fontSize: 17),
//                           )),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                             backgroundColor: AppColors.fadeTeal,
//                           ),
//                           onPressed: () async {
//                             await bluetoothClassicPlugin.initPermissions();
//                           },
//                           child: const Text(
//                             "Check Permissions",
//                             style: TextStyle(color: AppColors.black),
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       SizedBox(
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                             backgroundColor: AppColors.fadeTeal,
//                           ),
//                           onPressed: () {
//                             _getDevices();
//                           },
//                           child: const Text("Get Paired Devices",
//                               style: TextStyle(color: AppColors.black)),
//                         ),
//                       ),
//                       // ElevatedButton(
//                       //   onPressed: _deviceStatus == MyDevice.connected
//                       //       ? () async {
//                       //           await _bluetoothClassicPlugin.disconnect();
//                       //         }
//                       //       : null,
//                       //   child: const Text("Disconnect"),
//                       // ),
//                     ],
//                   ),

//                   const SizedBox(height: 10),
//                   // ElevatedButton(
//                   //   onPressed: _deviceStatus == MyDevice.connected
//                   //       ? () async {
//                   //           await _bluetoothClassicPlugin.write("ping");
//                   //         }
//                   //       : null,
//                   //   child: const Text("Send Ping"),
//                   // ),
//                   // SizedBox(height: 20),
//                   Center(
//                     child: Text('Running on: $_platformVersion\n'),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_devices.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Paired Devices:',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         const SizedBox(height: 10),
//                         // ..._devices.map((device) => TextButton(
//                         //       onPressed: () async {
//                         //         await _bluetoothClassicPlugin.connect(
//                         //             device.address,
//                         //             "00001101-0000-1000-8000-00805f9b34fb");
//                         //         setState(() {
//                         //           _discoveredDevices = [];
//                         //           _devices = [];
//                         //           _deviceName = device.name ?? '';
//                         //         });
//                         //       },
//                         //       child: Text(device.name ?? device.address),
//                         //     )),
//                         ..._devices.map((device) => Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(device.name),
//                                 const Spacer(),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: TextButton(
//                                       onPressed: () async {
//                                         loading = true;
//                                         deviceName = device.name;
//                                         try {
//                                           await bluetoothClassicPlugin.connect(
//                                               device.address,
//                                               "00001101-0000-1000-8000-00805f9b34fb");
//                                           loading = false;
//                                         } catch (e) {
//                                           loading = false;
//                                           Fluttertoast.showToast(
//                                               msg:
//                                                   "Unable to connect to $deviceName");
//                                           print(
//                                               "error connecting to device.name${e.toString()}");
//                                         }
//                                         setState(() {
//                                           _discoveredDevices = [];
//                                           _devices = [];
//                                           _deviceName = device.name;
//                                         });
//                                       },
//                                       child: const Text("Connect")),
//                                 ),
//                               ],
//                             ))
//                       ],
//                     ),
//                   const SizedBox(height: 20),
//                   // ElevatedButton(
//                   //   onPressed: _scan,
//                   //   child: Text(_scanning ? "Stop Scan" : "Start Scan"),
//                   // ),
//                   const SizedBox(height: 20),
//                   if (_discoveredDevices.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Discovered Devices:',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         const SizedBox(height: 10),
//                         ..._discoveredDevices.map((device) => Text(
//                               device.name,
//                               style: const TextStyle(fontSize: 16),
//                             )),
//                       ],
//                     ),
//                 ],
//               ),
//               if (loading)
//                 Center(
//                   child: Container(
//                     decoration: BoxDecoration(color: AppColors.teal.shade50),
//                     child: Column(
//                       children: [
//                         const CircularProgressIndicator(),
//                         Text("Connecting to $deviceName bt")
//                       ],
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//       // bottomNavigationBar: bottomNav(context, _stableWeight),
//     );
//   }
// }

class WeighPage extends StatefulWidget {
  const WeighPage({super.key});

  @override
  State<WeighPage> createState() => _WeighPageState();
}

class _WeighPageState extends State<WeighPage> {
  late StreamSubscription deviceStatusSubscription;
  late StreamSubscription deviceDataSubscription;
  late Stream deviceStatusStream;
  late Stream deviceDataStream;
  String _platformVersion = 'Unknown';
  // final _bluetoothClassicPlugin = BluetoothClassic();
  List<MyDevice> _devices = [];
  List<MyDevice> _discoveredDevices = [];
  bool _scanning = false;
  int _deviceStatus = MyDevice.disconnected;
  String _deviceName = '';
  String _stableWeight = '';
  final logger = Logger();
  late WeightNotifier weightNotifier;
  TextEditingController deductWeightCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    weightNotifier = WeightNotifier(3); // Set your stability threshold
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
          _deviceStatus = (event == 2 ? 1 : event);
        });
      }
    });

    deviceDataSubscription = deviceDataStream.listen((event) {
      weightNotifier.appendData(event);
    });
  }

  @override
  void dispose() {
    deviceStatusSubscription.cancel();
    deviceDataSubscription.cancel();
    weightNotifier.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      if (!mounted) return;
      platformVersion = await bluetoothClassicPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _getDevices() async {
    var res = await bluetoothClassicPlugin.getPairedDevices();
    if (mounted) {
      setState(() {
        _devices = res
            .map((device) => MyDevice(device.name ?? '', device.address))
            .toList();
      });
    }
  }

  Future<void> _scan() async {
    if (_scanning) {
      await bluetoothClassicPlugin.stopScan();
      if (mounted) {
        setState(() {
          _scanning = false;
        });
      }
    } else {
      await bluetoothClassicPlugin.startScan();
      bluetoothClassicPlugin.onDeviceDiscovered().listen(
        (event) {
          if (mounted) {
            setState(() {
              _discoveredDevices = [
                ..._discoveredDevices,
                MyDevice(event.name ?? '', event.address)
              ];
            });
          }
        },
      );
      if (mounted) {
        setState(() {
          _stableWeight = weightNotifier.weight;
        });
      }
    }
  }

  void _confirmWeight() {
    print("called methoooooooood");
    if (mounted) {
      setState(() {
        _stableWeight = weightNotifier.weight;
      });
    }
    logger.i('Stable Weight: $_stableWeight');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => weightNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weighing Page'),
          backgroundColor: AppColors.fadeTeal,
          centerTitle: true,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: Consumer<WeightNotifier>(
                    builder: (context, notifier, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              notifier.weight,
                              style: TextStyle(
                                fontSize: 48,
                                color: notifier.isStable
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'KG',
                              style: TextStyle(
                                fontSize: 24,
                                color: notifier.isStable
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<WeightNotifier>(
                  builder: (context, notifier, child) {
                    return Row(
                      children: [
                        const Text(
                          'Stable: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          notifier.isStable ? Icons.check_circle : Icons.cancel,
                          color: notifier.isStable ? Colors.green : Colors.red,
                          size: 26,
                        ),
                        const SizedBox(width: 5),
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Device Name: $_deviceName',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      'Status: $_deviceStatus',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<WeightNotifier>(
                        builder: (context, notifier, child) {
                      return ElevatedButton(
                          onPressed: notifier.isStable ? _confirmWeight : null,
                          child: const Text(
                            "Confirm Weight",
                            style: TextStyle(),
                          ));
                    }),
                    const Spacer(),
                    Text(
                      'Stable: $_stableWeight KG',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                textField("To Deduct", TextInputType.number, Icons.numbers,
                    deductWeightCont, "enter educt weight"),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal),
                      onPressed: () {
                        if (_stableWeight.isEmpty ||
                            deductWeightCont.text.trim().isEmpty) {
                          showSnackbar(context, "weights are required");
                        } else {
                          double actualWeight = double.parse(_stableWeight) - double.parse(deductWeightCont.text);
                          print("weight deducted $actualWeight");
                          Navigator.pop(context, actualWeight);
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
                        child: const Text("Get Paired Devices",
                            style: TextStyle(color: AppColors.black)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text('Running on: $_platformVersion\n'),
                ),
                const SizedBox(height: 20),
                if (_devices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paired Devices:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      ..._devices.map((device) => Row(
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
                                          "00001101-0000-1000-8000-00805f9b34fb");
                                      setState(() {
                                        _discoveredDevices = [];
                                        _devices = [];
                                        _deviceName = device.name;
                                      });
                                    },
                                    child: const Text("Connect")),
                              ),
                            ],
                          ))
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
                      ..._discoveredDevices.map((device) => Text(
                            device.name,
                            style: const TextStyle(fontSize: 16),
                          )),
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
