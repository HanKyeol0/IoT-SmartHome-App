import '../services/api_service.dart';

// UserData.dart
class UserData {
  final String createdAt;
  final String updatedAt;
  final int id;
  final String name;
  final String? mac;
  final String loginCode;
  final String dong;
  final String ho;
  final String? currentCar;
  final String currentHashedRefreshToken;
  final String role;
  String accessToken;
  String refreshToken;

  UserData(
      {required this.createdAt,
      required this.updatedAt,
      required this.id,
      required this.name,
      this.mac,
      required this.loginCode,
      required this.dong,
      required this.ho,
      this.currentCar,
      required this.currentHashedRefreshToken,
      required this.role,
      required this.accessToken,
      required this.refreshToken});

  factory UserData.fromJson(Map<String, dynamic> userData) {
    return UserData(
        createdAt: userData['data']['user']['createdAt'],
        updatedAt: userData['data']['user']['updatedAt'],
        id: userData['data']['user']['id'],
        name: userData['data']['user']['name'],
        mac: userData['data']['user']['mac'],
        loginCode: userData['data']['user']['loginCode'],
        dong: userData['data']['user']['dong'],
        ho: userData['data']['user']['ho'],
        currentCar: userData['data']['user']['currentCar'],
        currentHashedRefreshToken: userData['data']['user']
            ['currentHashedRefreshToken'],
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

class AccessLogs {
  final String time, type, id, label;

  AccessLogs({
    required this.time,
    required this.type,
    required this.id,
    required this.label,
  });
}

//id, building, onepass, mac, time, type, createdAt, updatedAt, id, label, floor, lines