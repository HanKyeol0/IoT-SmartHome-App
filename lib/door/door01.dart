import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/field.dart';
import '../widgets/button.dart';
import '../services/api_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

Future<String?> getWifiBSSID() async {
  final NetworkInfo info = NetworkInfo();
  final String? wifiBSSID = await info.getWifiBSSID();
  // ignore: avoid_print
  print("Wifi BSSID: $wifiBSSID");
  return wifiBSSID;
}

class BleDevice {
  String deviceId;
  String manufacturerSpecificData;
  int rssi;

  BleDevice({
    required this.deviceId,
    required this.manufacturerSpecificData,
    required this.rssi,
  });

  @override
  String toString() {
    return 'BleDevice { deviceId: $deviceId, manufacturerSpecificData: $manufacturerSpecificData, rssi: $rssi }';
  }
}

class Door01 extends StatefulWidget {
  const Door01({Key? key}) : super(key: key);

  @override
  State<Door01> createState() => _Door01State();
}

class _Door01State extends State<Door01> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();
  StreamSubscription<List<ScanResult>>? scanSubscription;
  bool isSwitched = false;
  final Future<List<AccessLogList>?> logs = ApiService.getAccessLogs();
  GlobalData globalData = GlobalData();
  List<BleDevice> devices = [];

  @override
  void initState() {
    super.initState();
    // ignore: unused_local_variable
    Future<String?> macAddress = getWifiBSSID();
    ApiService.getAccessLogs();
  }

  scanAdvertise() {
    startScan();
    bleAdvertise();
  }

  Future<void> startScan() async {
    int maxRssi = -999; // a large negative value to compare with actual RSSI
    BleDevice? maxRssiDevice;

    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        result.advertisementData.manufacturerData
            .forEach((id, manufacturerSpecificData) {
          var hexData = manufacturerSpecificData
              .map((data) => data.toRadixString(16).padLeft(2, '0'))
              .join();
          if (hexData.contains("4c4354")) {
            // Lux device code
            if (result.rssi > maxRssi) {
              // only store the device if its RSSI is greater than the current max
              maxRssi = result.rssi;
              maxRssiDevice = BleDevice(
                  deviceId: "${result.device.id}",
                  manufacturerSpecificData: hexData,
                  rssi: result.rssi);
            }
          }
        });
      }
    });

    flutterBlue.startScan(timeout: const Duration(seconds: 3)).then((_) {
      bleAdvertise();
      scanSubscription?.cancel();

      if (maxRssiDevice != null) {
        // ignore: avoid_print
        print(maxRssiDevice);
      } else {
        // ignore: avoid_print
        print("No device found");
      }
    });
  }

  void bleAdvertise() async {
    var data = [
      0x4C,
      0x55,
      0x42,
      0x00,
      0x21,
      0x04,
      0xB0,
      0x00,
      0x00,
      0x04,
      0x43,
      0x00,
      0xB1,
      0x41,
      0x0A,
      0x4F,
      0x50,
      0x41,
      0x00,
      0x01,
      0x00,
      0x00
    ];
    try {
      AdvertiseData? advertiseData =
          AdvertiseData(manufacturerData: Uint8List.fromList(data));
      print('here is the data: ${Uint8List.fromList(data)}');
      await FlutterBlePeripheral().start(advertiseData: advertiseData);
    } catch (e) {
      // ignore: avoid_print
      print('Error during BLE advertisement: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 0,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 91),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      '공동현관',
                      style: titleText(fontSize: 21),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Text(
                            '자동출입',
                            style: fieldTitle(fontSize: 14),
                          ),
                          const SizedBox(width: 7),
                          const AutoAccessToggle(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            '출입기록',
                            style: fieldTitle(),
                          ),
                          const Spacer(),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: SeeMoreButton(), //'더보기' button
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          FutureBuilder<List<AccessLogList>?>(
                            future: logs,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: 3,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var log = snapshot.data![index];
                                    return AccessLog(
                                      bgColor: darkGrey,
                                      iconBoxColor: black,
                                      isKey:
                                          log.type == "smartkey" ? true : false,
                                      accessTime: log.time,
                                      floor: log.floor,
                                      label: log.label,
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'error: ${snapshot.error}',
                                  style: const TextStyle(color: wColor),
                                );
                              } else {
                                return const Center(
                                  child:
                                      CircularProgressIndicator(color: bColor),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    GateAccess(
                      isDetected: true,
                      onPressed: startScan,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          const GateDetection(isDetected: true),
        ],
      ),
    );
  }
}

void advertiseToCCTV(String macAddress, String deviceId) {
  List<int> macAddressBytes =
      macAddress.split("-").map((e) => int.parse(e, radix: 16)).toList();
  List<int> deviceIdBytes =
      deviceId.split("-").map((e) => int.parse(e, radix: 16)).toList();

  List<int> payload = [
    0x4C,
    0x55,
    0x42,
    0x00,
    ...macAddressBytes,
    ...deviceIdBytes,
    0x4F,
    0x50,
    0x41,
    0x00,
    0xFF,
    0x00,
    0x00,
  ];

  if (payload.length > 31) {
    // ignore: avoid_print
    print("Payload size exceeds 31 bytes limit");
    return;
  }
}
