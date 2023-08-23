import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/field.dart';
import '../widgets/button.dart';
import '../services/api_service.dart';
import 'dart:async';
import 'package:luxrobo/ble_platform_channel.dart';

class Door01Android extends StatefulWidget {
  const Door01Android({Key? key}) : super(key: key);

  @override
  State<Door01Android> createState() => _Door01AndroidState();
}

class _Door01AndroidState extends State<Door01Android> {
  bool isGateDetected = true;
  final Future<List<AccessLogList>?> logs = ApiService.getAccessLogs();
  GlobalData globalData = GlobalData();
  UserData? userData = GlobalData().userData;

  @override
  void initState() {
    super.initState();
    ApiService.getAccessLogs();
  }

  void gateDetection() {
    setState(() {
      isGateDetected = true;
    });
  }

  void androidBle() {
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set - mac address');
    } else {
      print(userData!.mac);
    }
    print(userData!.mac);
    BLEPlatformChannel.startAdvertising(userData!.mac);
    print('start');

    Future.delayed(Duration(seconds: 10), () {
      BLEPlatformChannel.stopAdvertising();
      print('end');
    });
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
                        onPressed: androidBle,
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
