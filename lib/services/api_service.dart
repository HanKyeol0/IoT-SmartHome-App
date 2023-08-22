import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luxrobo/services/api_data.dart';

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

  static Future<String> getPakingPlace(apartmentId) async {
    final queryParameters = {
      'mapImage': apartmentId,
    };

    final url =
        Uri.http('13.125.92.61:8080', '/$getParkingPlace', queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final parkingPlaceData = jsonDecode(response.body);
      final mapImageUrl = parkingPlaceData['data']['parkingMap']['mapImage'];
      print(mapImageUrl);
      return mapImageUrl;
    } else if (response.statusCode == 400) {
      return 'no parking lot data';
    } else {
      return 'bad internet';
    }
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

    if (apartment != null) {
      final int apartmentID = apartment['id'] as int;
      return apartmentID;
    } else {
      return null;
    }
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
