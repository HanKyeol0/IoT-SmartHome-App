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

  //car
  static const String postCar = 'api/car';

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
  static Future<void> getAccessLogs() async {
    UserData? userData = GlobalData().userData;
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set');
      return;
    }

    final url = Uri.parse('$baseurl/$getOnepassLogs');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${userData.accessToken}',
        //'Refresh-Token': userData.refreshToken,
      },
    );

    if (response.statusCode == 201) {
      final List<dynamic> logs = jsonDecode(response.body);
      for (var log in logs) {
        print(log);
      }
    } else if (response.statusCode == 401) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  //postCar
  static Future<void> saveCar(String carNumber) async {
    final url = Uri.parse('$baseurl/$postCar');

    final requestBody = jsonEncode({'number': carNumber});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
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
}
