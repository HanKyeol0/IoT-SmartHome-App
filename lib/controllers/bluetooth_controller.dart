import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  StreamSubscription<List<ScanResult>>? scanSubscription;
  final scanResultsController = StreamController<List<ScanResult>>();

  // scan devices for Bluetooth connection
  Future scanDevices() async {
    flutterBlue.startScan(timeout: const Duration(seconds: 5));

    // Wait for the specified duration and then stop scanning
    // await Future.delayed(const Duration(seconds: 5));
    flutterBlue.stopScan();
  }

  // Dispose of the stream subscription and controller when no longer needed
  @override
  void dispose() {
    scanSubscription?.cancel();
    scanResultsController.close();
    super.dispose();
  }

  Stream<List<ScanResult>> get scanResults => scanResultsController.stream;
}
