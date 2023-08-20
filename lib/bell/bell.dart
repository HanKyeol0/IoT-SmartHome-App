import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:luxrobo/ble_platform_channel.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';

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

class Bell extends StatefulWidget {
  const Bell({Key? key}) : super(key: key);

  @override
  State<Bell> createState() => _BellState();
}

class _BellState extends State<Bell> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  StreamSubscription<List<ScanResult>>? scanSubscription;
  GlobalData globalData = GlobalData();
  UserData? userData = GlobalData().userData;
  String? cctvId;

  @override
  void initState() {
    super.initState();
    findNearestCCTV().then((id) {
      setState(() {
        cctvId = id;
      });
    });
  }

  Future<void> print1() async {
    // ignore: avoid_print
    print('1');
  }

  Future<String> findNearestCCTV() async {
    int maxRssi = -999; // a large negative value to compare with actual RSSI
    BleDevice? maxRssiDevice;

    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        //print(result);
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

    if (maxRssiDevice != null) {
      print(maxRssiDevice);
      return maxRssiDevice!.deviceId;
      // ignore: avoid_print
      //gateDetection();
    } else {
      // ignore: avoid_print
      print("No device found");
      return '1';
    }
  }

  void cctvAdvertising(cctvId) {
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set - mac address');
    } else {
      print(userData!.mac);
    }
    BLEPlatformChannel.cctvAdvertising(userData!.mac, cctvId);
    print('start');

    Future.delayed(Duration(seconds: 10), () {
      BLEPlatformChannel.stopAdvertising();
      print('end');
    });
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 2,
      body: Column(
        children: [
          const SizedBox(height: 91),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '비상벨',
                style: titleText(),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmergencyBell(onPressed: () {
                    if (cctvId != null) {
                      cctvAdvertising(cctvId!);
                    } else {
                      print('CCTV ID not available yet');
                    }
                  }),
                  const SizedBox(height: 50),
                  Text(
                    '비상 시 1초간 꾹 눌러주세요.',
                    style: emergencyBellContent(),
                  ),
                  Text(
                    '주변 CCTV로 연결됩니다.',
                    style: emergencyBellContent(),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
