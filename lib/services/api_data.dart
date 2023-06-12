/*

class UserData {
  final String createdAt;
  final String updatedAt;
  final int id;
  final String name;
  final String? mac;
  final String? loginCode;
  final String? dong;
  final String? ho;
  final String? currentCar;
  final String currentHashedRefreshToken;
  final String role;
  final String accessToken;
  final String refreshToken;

  UserData.fromJson(Map<String, dynamic> userData)
      : createdAt: userData['data']['user']['createdAt'],
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
*/

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
  final String accessToken;
  final String refreshToken;

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
