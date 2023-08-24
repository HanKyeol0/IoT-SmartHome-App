import 'package:flutter/services.dart';

class BLEPlatformChannel {
  static const platform = const MethodChannel("luxrobo/ble");

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

  static Future<void> bellAdvertising(String? uuid, String? cctvId) async {
    try {
      print('bell advertising started');
      await platform.invokeMethod('bellAdvertising', {
        'data1': uuid,
        'data2': cctvId,
      });
    } on PlatformException catch (e) {
      print("Failed to start advertising: ${e.message}");
    }
  }

  static Future<void> bellAdvertisingTest() async {
    try {
      await platform.invokeMethod('bellAdvertisingTest');
      print('Test bell advertising');
    } on PlatformException catch (e) {
      print("Failed to start advertising: ${e.message}");
    }
  }

  static Future<void> parkingAdvertising(String? uuid, String? cctvId) async {
    try {
      await platform.invokeMethod('parkingAdvertising', {
        'data1': uuid,
        'data2': cctvId,
      });
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
