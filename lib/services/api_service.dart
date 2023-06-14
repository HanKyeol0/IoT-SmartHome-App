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

  //getApartment
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
      for (var log in logs) {
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
      print('${response.statusCode}: ${response.body}');
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
      print(response.statusCode);
      // ignore: avoid_print
      print(response.body);
    }
    return null;
  }
}
