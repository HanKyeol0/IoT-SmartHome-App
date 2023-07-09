import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:luxrobo/controllers/bluetooth_controller.dart';
import 'package:get/get.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';

class BLEtest extends StatefulWidget {
  const BLEtest({super.key});

  @override
  State<BLEtest> createState() => _BLEtestState();
}

class _BLEtestState extends State<BLEtest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController>(
          init: BluetoothController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  //go back to the login 01 page
                  GoBack(
                    onPressed: () => Navigator.pushNamed(context, '/login01'),
                  ),
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: bColor,
                    child: Center(
                      child: Text(
                        "BLE testing page",
                        style: titleText(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => controller.scanDevices(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: wColor,
                        backgroundColor: bColor,
                        minimumSize: const Size(350, 55),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      child: Text(
                        "Scan",
                        style: contentText(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  StreamBuilder<List<ScanResult>>(
                      stream: controller.scanResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final data = snapshot.data![index];
                                return Card(
                                  elevation: 2,
                                  child: ListTile(
                                    title: Text(data.device.name),
                                    subtitle: Text(data.device.id.id),
                                    trailing: Text(data.rssi.toString()),
                                  ),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text("No devices found"),
                          );
                        }
                      }),
                ],
              ),
            );
          }),
    );
  }
}
