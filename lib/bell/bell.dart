import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';

class Bell extends StatefulWidget {
  const Bell({Key? key}) : super(key: key);

  @override
  State<Bell> createState() => _BellState();
}

class _BellState extends State<Bell> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  StreamSubscription<List<ScanResult>>? scanSubscription;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        result.advertisementData.manufacturerData
            .forEach((id, manufacturerSpecificData) {
          var hexData = manufacturerSpecificData
              .map((data) => data.toRadixString(16).padLeft(2, '0'))
              .join();
          if (hexData.contains("4c4354")) {
            print("1");
          }
        });
        // ignore: avoid_print
        if ("${result.device.id}" == "34:B4:72:94:76:06") {
          // ignore: avoid_print
          print(
              'Found device: ${result.device.id} c(${result.advertisementData.manufacturerData}) h(${result.rssi})');
          result.advertisementData.manufacturerData.forEach((id, bytes) {
            var hexString = bytes
                .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                .join();
            print('Found device: id=$id, data=$hexString');
          });
        }
        // Add your desired logic to handle the Bluetooth response here
      }
    });

    flutterBlue.startScan(timeout: const Duration(seconds: 10));
  }

  Future<void> print1() async {
    // ignore: avoid_print
    print('1');
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
                  EmergencyBell(onPressed: print1),
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
