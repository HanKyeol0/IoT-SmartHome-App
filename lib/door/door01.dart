import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/field.dart';
import '../widgets/button.dart';
import '../services/api_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

class BleDevice {
  String deviceId;
  String manufacturerSpecificData;

  BleDevice({
    required this.deviceId,
    required this.manufacturerSpecificData,
  });
}

class Door01 extends StatefulWidget {
  const Door01({Key? key}) : super(key: key);

  @override
  State<Door01> createState() => _Door01State();
}

class _Door01State extends State<Door01> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  StreamSubscription<List<ScanResult>>? scanSubscription;
  bool isSwitched = false;
  final Future<List<AccessLogList>?> logs = ApiService.getAccessLogs();
  GlobalData globalData = GlobalData();
  List<BleDevice> devices = [];

  @override
  void initState() {
    super.initState();
    ApiService.getAccessLogs();
    startScan();
  }

  void startScan() {
    devices = []; // initialize the BLE devices list
    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        result.advertisementData.manufacturerData
            .forEach((id, manufacturerSpecificData) {
          var hexData = manufacturerSpecificData
              .map((data) => data.toRadixString(16).padLeft(2, '0'))
              .join();
          if (hexData.contains("4c4354")) {
            devices.add(BleDevice(
                deviceId: "${result.device.id}",
                manufacturerSpecificData: hexData));
            // ignore: avoid_print
            print(devices);
          }
        });
      }
    });

    flutterBlue.startScan(timeout: const Duration(seconds: 10));
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
                    const GateAccess(
                      isDetected: true,
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
