import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:luxrobo/device_storage.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/field.dart';
import '../widgets/button.dart';
import '../services/api_service.dart';
import 'dart:async';
import 'package:luxrobo/ble_platform_channel.dart';

class Door01 extends StatefulWidget {
  const Door01({Key? key}) : super(key: key);

  @override
  State<Door01> createState() => _Door01State();
}

class _Door01State extends State<Door01> {
  bool isGateDetected = true;
  final Future<List<AccessLogList>?> logs = ApiService.getAccessLogs();
  GlobalData globalData = GlobalData();
  UserData? userData = GlobalData().userData;
  bool autoGateAccess = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAutoAccess();
    automaticGateAccess();
  }

  void gateDetection() {
    setState(() {
      isGateDetected = true;
    });
  }

  void gateAccessAdvertising() {
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set - mac address');
    } else {
      print('here is the user mac: ${userData!.mac}');
      BLEPlatformChannel.gateAdvertising(userData!.mac);
      print('gate advertising start');

      Future.delayed(Duration(seconds: 5), () {
        BLEPlatformChannel.stopAdvertising();
        print('end');
      });
    }
  }

  void automaticGateAccess() {
    if (autoGateAccess == true) {
      gateAccessAdvertising();
    } else {
      return;
    }
  }

  void _saveAutoAccess() {
    AutoGateAccess().saveAutoAccess(
      autoGate: autoGateAccess,
    );
  }

  void _loadSavedAutoAccess() async {
    Map<String, dynamic> autoAcceessInfo =
        await AutoGateAccess().retrieveAutoAccess();
    if (autoAcceessInfo[AutoGateAccess.keyAutoAccess] == true) {
      setState(() {
        autoGateAccess = true;
      });
    } else {
      setState(() {
        autoGateAccess = false;
      });
    }
  }

  void checkBluetoothState() async {
    final isOn = await FlutterBluePlus.turnOn();
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
                          //자동출입
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                autoGateAccess = !autoGateAccess;
                              });
                              automaticGateAccess();
                            },
                            child: Container(
                              width: 45,
                              height: 26,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: autoGateAccess ? bColor : lightGrey,
                              ),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.ease,
                                    left: autoGateAccess ? 20.0 : 0.0,
                                    right: autoGateAccess ? 0.0 : 20.0,
                                    top: 3.2,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          autoGateAccess = !autoGateAccess;
                                        });
                                        _saveAutoAccess();
                                      },
                                      child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: autoGateAccess
                                              ? thickBlue
                                              : black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(
                child: SingleChildScrollView(
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
                      SizedBox(
                        height: 230,
                        child: Column(
                          children: [
                            FutureBuilder<List<AccessLogList>?>(
                              future: logs,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length > 3
                                        ? 3
                                        : snapshot.data!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var log = snapshot.data![index];
                                      return AccessLog(
                                        bgColor: darkGrey,
                                        iconBoxColor: black,
                                        isKey: log.type == "smartkey"
                                            ? true
                                            : false,
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
                                    child: SizedBox(
                                        height: 230,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              color: bColor),
                                        )),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      GateAccess(
                        isDetected: isGateDetected,
                        onPressed: gateAccessAdvertising,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //GateDetection(isDetected: isGateDetected),
        ],
      ),
    );
  }
}
