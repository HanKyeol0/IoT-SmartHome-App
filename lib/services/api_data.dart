import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// UserData.dart
class UserData {
  String createdAt;
  int id;
  String name;
  String? mac;
  String loginCode;
  String dong;
  String ho;
  String? currentCar;
  String role;
  String accessToken;
  String refreshToken;

  UserData(
      {required this.createdAt,
      required this.id,
      required this.name,
      this.mac,
      required this.loginCode,
      required this.dong,
      required this.ho,
      this.currentCar,
      required this.role,
      required this.accessToken,
      required this.refreshToken});

  factory UserData.fromJson(Map<String, dynamic> userData) {
    return UserData(
        createdAt: userData['data']['user']['createdAt'],
        id: userData['data']['user']['id'],
        name: userData['data']['user']['name'],
        mac: userData['data']['user']['mac'],
        loginCode: userData['data']['user']['loginCode'],
        dong: userData['data']['user']['dong'],
        ho: userData['data']['user']['ho'],
        currentCar: userData['data']['user']['currentCar'],
        role: userData['data']['user']['role'],
        accessToken: userData['data']['token']['accessToken'],
        refreshToken: userData['data']['token']['refreshToken']);
  }

  Future<void> updateTokens() async {
    try {
      final newTokens =
          await ApiService.reissueTokens(accessToken, refreshToken);
      accessToken = newTokens['data']['accessToken'];
      refreshToken = newTokens['data']['refreshToken'];
    } catch (e) {
      // ignore: avoid_print
      print('Failed to update tokens: $e');
    }
  }
}

// Globally used data
class GlobalData {
  static final GlobalData _singleton = GlobalData._internal();

  factory GlobalData() {
    return _singleton;
  }

  GlobalData._internal();

  UserData? userData;
  int? apartmentID;

  int? get getApartmentID => apartmentID;

  void setApartmentID(int? id) {
    apartmentID = id;
  }

  void setUserData(UserData data) {
    userData = data;
  }

  static GlobalData getInstance() {
    return _singleton;
  }

  // log-out function
  void logOut() async {
    userData = null;
    apartmentID = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

class TokenData {
  final String accessToken;
  final String refreshToken;

  TokenData({required this.accessToken, required this.refreshToken});

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

//gate access log
class AccessLogList {
  final String time, label, floor, type;

  AccessLogList({
    required this.time,
    required this.label,
    required this.floor,
    required this.type,
  });

  factory AccessLogList.fromJson(Map<String, dynamic> log) {
    return AccessLogList(
      time: log['time'],
      label: log['gate']['label'],
      floor: log['gate']['floor'],
      type: log['type'],
    );
  }
}

class ApartmentList {
  final int id;
  final String name;

  ApartmentList({
    required this.id,
    required this.name,
  });

  factory ApartmentList.fromJson(Map<String, dynamic> apartment) {
    return ApartmentList(
      id: apartment['id'],
      name: apartment['name'],
    );
  }
}

class CarList {
  final int id;
  final String number;

  CarList({
    required this.id,
    required this.number,
  });

  factory CarList.fromJson(Map<String, dynamic> car) {
    return CarList(
      id: car['id'],
      number: car['number'],
    );
  }
}

//선호 주차장 리스트
class ParkingLotList {
  final Map<int, String> parkinglot;

  ParkingLotList({
    required this.parkinglot,
  });

  factory ParkingLotList.fromJson(Map<String, dynamic> lot) {
    return ParkingLotList(parkinglot: {
      lot['id']: lot['place'],
    });
  }
}

//parking place
class ParkingPlace {
  final String mapImage;
  final String place;
  final DateTime time;
  final int upperLeftX;
  final int upperLeftY;
  final int lowRightX;
  final int lowRightY;

  ParkingPlace({
    required this.mapImage,
    required this.place,
    required this.time,
    required this.upperLeftX,
    required this.upperLeftY,
    required this.lowRightX,
    required this.lowRightY,
  });

  factory ParkingPlace.fromJson(Map<String, dynamic> place) {
    return ParkingPlace(
      mapImage: place['mapImage'],
      place: place['place'],
      time: DateTime.parse(place['updatedAt'] as String),
      upperLeftX: place['cctv'][0]['upperLeftX'],
      upperLeftY: place['cctv'][0]['upperLeftY'],
      lowRightX: place['cctv'][0]['lowRightX'],
      lowRightY: place['cctv'][0]['lowRightY'],
    );
  }
}

//현재 선호 주차장
class PreferredLocation {
  final int id;
  final String mapImage;
  final String place;

  PreferredLocation({
    required this.id,
    required this.mapImage,
    required this.place,
  });

  factory PreferredLocation.fromJson(Map<String, dynamic> location) {
    return PreferredLocation(
      id: location['id'],
      mapImage: location['mapImage'],
      place: location['place'],
    );
  }
}

class BleDeviceInfoList {
  final String id, manufacturerSpecificData;

  BleDeviceInfoList({
    required this.id,
    required this.manufacturerSpecificData,
  });
}
