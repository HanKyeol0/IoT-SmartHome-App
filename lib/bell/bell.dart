import 'dart:async';
import 'package:beacon_broadcast/beacon_broadcast.dart';
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
  StreamSubscription<List<ScanResult>>? scanSubscription;
  GlobalData globalData = GlobalData();
  UserData? userData = GlobalData().userData;
  String? cctvId;
  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  @override
  void initState() {
    super.initState();
    findNearestCCTV();
    Future.delayed(Duration(seconds: 5), () {
      print('hello this is the cctvID : $cctvId');
    });
  }

  Future<String?> findNearestCCTV() async {
    await FlutterBluePlus.stopScan();

    int maxRssi = -999; // a large negative value to compare with actual RSSI
    BleDevice? maxRssiDevice;

    scanSubscription?.cancel();

    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
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
              //print(id);
              maxRssiDevice = BleDevice(
                  deviceId: "${result.device.remoteId}",
                  manufacturerSpecificData: hexData,
                  rssi: result.rssi);
            }
          }
        });
      }
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 3))
        .then((_) async {
      if (maxRssiDevice != null) {
        print('here is the device: $maxRssiDevice');
        setState(() {
          cctvId = maxRssiDevice!.manufacturerSpecificData.substring(0, 10);
        });
      } else {
        // ignore: avoid_print
        print("No device found");
      }
    });
    return null;
  }

  void cctvBellAdvertising(cctvId) {
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set - mac address');
    } else {
      print('here is the user mac: ${userData!.mac}');

      BLEPlatformChannel.bellAdvertising(userData!.mac, cctvId);
      //BLEPlatformChannel.bellAdvertisingTest();
      print('bell test advertising in bell page');
      print('start');

      Future.delayed(Duration(seconds: 5), () {
        BLEPlatformChannel.stopAdvertising();
        print('end');
      });
    }
  }

  void cctvDetectionFailed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: darkGrey,
          elevation: 0.0, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'CCTV BLE가 감지되지 않습니다.',
                  style: titleText(),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
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
                  EmergencyBell(longPressed: () {
                    if (cctvId != null) {
                      print('cctv found');
                      cctvBellAdvertising(cctvId);
                      print(cctvId);
                    } else {
                      print('cctv not found');
                      cctvDetectionFailed(context);
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
