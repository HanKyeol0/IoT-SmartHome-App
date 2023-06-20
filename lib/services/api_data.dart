import '../services/api_service.dart';

// UserData.dart
class UserData {
  final String createdAt;
  final int id;
  final String name;
  final String? mac;
  final String loginCode;
  final String dong;
  final String ho;
  final String? currentCar;
  final String role;
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

class GlobalData {
  static final GlobalData _singleton = GlobalData._internal();

  factory GlobalData() {
    return _singleton;
  }

  GlobalData._internal();

  UserData? userData;

  void setUserData(UserData data) {
    userData = data;
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
