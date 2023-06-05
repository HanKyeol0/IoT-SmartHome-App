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

  UserData.fromJson(Map<String, dynamic> userData)
      : createdAt = userData['createdAt'],
        updatedAt = userData['updatedAt'],
        id = userData['id'],
        name = userData['name'],
        mac = userData['mac'],
        loginCode = userData['loginCode'],
        dong = userData['dong'],
        ho = userData['ho'],
        currentCar = userData['currentCar'],
        currentHashedRefreshToken = userData['currentHashedRefreshToken'],
        role = userData['role'];
}
