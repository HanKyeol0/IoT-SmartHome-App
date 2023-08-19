import 'package:flutter/services.dart';

class BLEPlatformChannel {
  static const platform = const MethodChannel('luxrobo/ble');

  static Future<void> startAdvertising(String? data) async {
    try {
      await platform.invokeMethod('startAdvertising', {'data': data});
    } on PlatformException catch (e) {
      print("Failed to start advertising: ${e.message}");
    }
  }

  static Future<void> gateAccessAdvertising() async {
    try {
      await platform.invokeMethod('gateAccessAdvertising');
    } on PlatformException catch (e) {
      print("Failed to start advertising: ${e.message}");
    }
  }

  static Future<void> stopAdvertising() async {
    try {
      await platform.invokeMethod('stopAdvertising');
    } on PlatformException catch (e) {
      print("Failed to stop advertising: ${e.message}");
    }
  }
}
