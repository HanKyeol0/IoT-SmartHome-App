import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  // scan devices for bluetooth connection
  Future scanDevices() async {
    //starting scan from here. scan for 5 seconds
    flutterBlue.startScan(timeout: const Duration(seconds: 5));

    //stop scanning
    flutterBlue.stopScan();
  }

  //show all available devices

  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
}
