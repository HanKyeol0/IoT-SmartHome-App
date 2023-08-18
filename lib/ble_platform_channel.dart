import 'package:flutter/services.dart';

class BLEPlatformChannel {
  static const platform = const MethodChannel('luxrobo/ble');

  static Future<void> startAdvertising() async {
    try {
      await platform.invokeMethod('startAdvertising');
    } on PlatformException catch (e) {
      // Handle potential errors here
      print("Failed to start advertising: ${e.message}");
    }
  }

  static Future<void> stopAdvertising() async {
    try {
      await platform.invokeMethod('stopAdvertising');
    } on PlatformException catch (e) {
      // Handle potential errors here
      print("Failed to stop advertising: ${e.message}");
    }
  }
}
