import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luxrobo/services/api_data.dart';

import '../widgets/dialog.dart';

class ApiService {
  static const String baseurl = 'http://13.125.92.61:8080';

  //Check Apartment
  static const String getApartment = 'api/apartment';

  //Login
  static const String postAuth = 'api/auth';

  //Onepass Logs
  static const String getOnepassLogs = 'api/onepass/logs';

  //reissue tokens
  static const String postAuthReissue = 'api/auth/reissue';

  //save car
  static const String postCar = 'api/car';

  //get car
  static const String getCar = 'api/car';

  //delete car
  static const String deleteCar = 'api/car';

  //get parking lot and map
  static const String getParkingLotMap = 'api/parkingmap/app';

  //get parking place
  static const String getParkingPlace = 'api/parkingplace';

  //put user's current car
  static const String putCurrentCar = 'api/user/car';

  //get user's current car
  static const String getCurrentCar = 'api/user/car';

  //get preferred parking location
  static const String getUserParkingMap = 'api/userParkingMap';

  //post parking map
  static const String postParkingLot = 'api/userParkingMap';

  //getApartment - fetch Apartment list
  static Future<List<ApartmentList>?> getApartmentList(searchWord) async {
    List<ApartmentList> apartmentList = [];
    final queryParameters = {
      'name': searchWord,
    };

    final url =
        Uri.http('13.125.92.61:8080', '/$getApartment', queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final apartments = jsonDecode(response.body);
      for (var apartment in apartments['data'][0]) {
        apartmentList.add(ApartmentList.fromJson(apartment));
        print('succeeded');
      }
      return apartmentList;
    } else if (response.statusCode == 500) {
      print('${response.statusCode}: ${response.body}');
    } else {
      print('nothing happened');
    }

    return null;
  }

  //getApartment - check Apartment ID
  static Future<int?> checkApartment(String value) async {
    final url = Uri.parse('$baseurl/$getApartment');
    final response = await http.get(url);

    final responseData = jsonDecode(response.body);
    final data = responseData['data'][0] as List<dynamic>;

    final apartment = data.firstWhere(
      (item) => item['name'] == value,
      orElse: () => null,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (apartment != null) {
        final int apartmentID = apartment['id'] as int;
        return apartmentID;
      } else {
        return null;
      }
    } else if (response.statusCode == 500) {
      unstableNetwork;
      return null;
    }
    return null;
  }

  //getOnepassLogs
  static Future<List<AccessLogList>?> getAccessLogs() async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;
    List<AccessLogList> accessLogList = [];

    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return null;
    }

    final url = Uri.parse('$baseurl/$getOnepassLogs');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final logs = jsonDecode(response.body);
      for (var log in logs['data']['data']) {
        accessLogList.add(AccessLogList.fromJson(log));
        // ignore: avoid_print
        print(log);
      }
      return accessLogList;
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
      await globalData.userData?.updateTokens();
      return await getAccessLogs();
    } else {
      // ignore: avoid_print
      print('${response.statusCode}: this is why it is 500.. ${response.body}');
    }
    return null;
  }

  //get parking place map
  static Future<ParkingPlace> getParkingPlaceMap() async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;

    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return ParkingPlace(
        mapImage: '2',
        place: '2',
        time: DateTime(2, 2, 2, 2, 2),
        lowRightX: 2,
        lowRightY: 2,
        upperLeftX: 2,
        upperLeftY: 2,
      );
    }

    final url = Uri.parse('$baseurl/$getParkingPlace');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final parkingPlaceData = jsonDecode(response.body);
      final parkingPlaceMap =
          parkingPlaceData['data']['parkingMap'] as Map<String, dynamic>;
      return ParkingPlace.fromJson(parkingPlaceMap);
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
      await globalData.userData?.updateTokens();
      return await getParkingPlaceMap();
    } else if (response.statusCode == 404) {
      return ParkingPlace(
        mapImage: '0',
        place: '주차 위치 조회 실패',
        time: DateTime(0, 0, 0, 0, 0),
        lowRightX: 0,
        lowRightY: 0,
        upperLeftX: 0,
        upperLeftY: 0,
      );
    } else {
      return ParkingPlace(
        mapImage: '1',
        place: '네트워크 오류',
        time: DateTime(1, 1, 1, 1, 1),
        lowRightX: 1,
        lowRightY: 1,
        upperLeftX: 1,
        upperLeftY: 1,
      );
    }
  }

  //get parking place map
  static Future<PreferredLocation> getPreferredLocation() async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;

    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return PreferredLocation(id: -1, mapImage: '3', place: '3');
    }

    final url = Uri.parse('$baseurl/$getUserParkingMap');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final locationData = jsonDecode(response.body);
      final userLocation = locationData['data']['parkingMap'];
      print(userLocation);
      return PreferredLocation.fromJson(userLocation);
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
      await globalData.userData?.updateTokens();
      return await getPreferredLocation();
    } else if (response.statusCode == 404) {
      return PreferredLocation(id: -1, mapImage: '0', place: '선호 주차장을 선택해주세요.');
    } else {
      return PreferredLocation(id: -1, mapImage: '0', place: '선호구역 조회 실패');
    }
  }

  //postReissueToken
  static Future<Map<String, dynamic>> reissueTokens(
      String accessToken, String refreshToken) async {
    final url = Uri.parse('$baseurl/$postAuthReissue');

    final requestBody = jsonEncode({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update tokens');
    }
  }

  //postCar
  static Future<void> saveCar(String carNumber) async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return;
    }

    final url = Uri.parse('$baseurl/$postCar');

    final requestBody = jsonEncode({'number': carNumber});

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
      body: requestBody,
    );

    if (response.statusCode == 201) {
      // ignore: avoid_print
      print('201: ${response.body}');
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('401: ${response.body}');
      await globalData.userData?.updateTokens();
      await saveCar(carNumber);
    } else {
      // ignore: avoid_print
      print(response.statusCode);
      // ignore: avoid_print
      print(response.body);
    }
  }

  static Future<void> postUserParkingLot(int parkingMapId) async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return;
    }

    final url = Uri.parse('$baseurl/$postParkingLot');

    final requestBody = jsonEncode({'parkingMapId': parkingMapId});

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
      body: requestBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('200: ${response.body}');
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('401: ${response.body}');
      await globalData.userData?.updateTokens();
      await postUserParkingLot(parkingMapId);
    } else {
      unstableNetwork;
    }
  }

  //putCurrentCar
  static Future<int> putUserCurrentCar(String carNumber) async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return 3;
    }

    final url = Uri.parse('$baseurl/$putCurrentCar');

    final requestBody = jsonEncode({'carNumber': carNumber});

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
      body: requestBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // ignore: avoid_print
      print('201: ${response.body}');
      return 1;
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('401: ${response.body}');
      await globalData.userData?.updateTokens();
      return await putUserCurrentCar(carNumber);
    } else {
      // ignore: avoid_print
      print(response.statusCode);
      // ignore: avoid_print
      print(response.body);
      return 2;
    }
  }

  //getUserCar
  static Future<List<CarList>?> getUserCar() async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;
    List<CarList> carList = [];

    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return null;
    }

    final url = Uri.parse('$baseurl/$getCar');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final cars = jsonDecode(response.body);
      for (var car in cars['data']['data']) {
        carList.add(CarList.fromJson(car));
      }
      return carList;
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('401: ${response.body}');
      await globalData.userData?.updateTokens();
      return await getUserCar();
    } else {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
    }
    return null;
  }

  //getCurrentCar
  static Future<String> getUserCurrentCar() async {
    //GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;

    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return '3';
    }

    final url = Uri.parse('$baseurl/$getCurrentCar');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final currentCarData = jsonDecode(response.body);
      final currentCar = currentCarData['data']['number'];
      return currentCar;
    } else if (response.statusCode == 404) {
      return '1';
    } else {
      return '2';
    }
  }

  //delete Car
  static Future<void> deleteUserCar(int carId) async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;

    if (userData == null) {
      // ignore: avoid_print
      print('user data is not set');
      return;
    }

    final url = Uri.parse('$baseurl/$deleteCar/$carId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
      await globalData.userData?.updateTokens();
      await deleteUserCar(carId);
    } else {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
    }
  }

  //getParkingLot
  static Future<List<ParkingLotList>?> getParkingLot() async {
    GlobalData globalData = GlobalData();
    UserData? userData = GlobalData().userData;
    List<ParkingLotList> parkingLotList = [];

    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return null;
    }

    final url = Uri.parse('$baseurl/$getParkingLotMap');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userData.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final lots = jsonDecode(response.body);
      for (var lot in lots['data']['data']) {
        parkingLotList.add(ParkingLotList.fromJson(lot));
      }
      return parkingLotList;
    } else if (response.statusCode == 401) {
      // ignore: avoid_print
      print('401: ${response.body}');
      await globalData.userData?.updateTokens();
      return await getParkingLot();
    } else {
      // ignore: avoid_print
      print('${response.statusCode}: ${response.body}');
    }
    return null;
  }
}
