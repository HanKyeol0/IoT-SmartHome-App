import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseurl = 'http://43.201.14.39:8080';

  //Check Apartment
  static const String getApartment = 'api/apartment';

  //Login
  static const String postAuth = 'api/auth';

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

  //postAuth
  static Future<bool> login(
    int apartmentID,
    String dong,
    String ho,
    String name,
    String loginCode,
  ) async {
    final url = Uri.parse('$baseurl/$postAuth');

    final requestBody = jsonEncode({
      'apartmentId': apartmentID,
      'dong': dong,
      'ho': ho,
      'name': name,
      'loginCode': loginCode,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      print('Logged in successfully: $responseBody');
      return true;
    } else {
      print('Login failed with status code: ${response.statusCode}');
      return false;
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

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      print('saved successfully: $responseBody');
    }
  }
}
