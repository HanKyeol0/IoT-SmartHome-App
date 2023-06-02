import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseurl = 'http://43.201.14.39:8080';

  static const String postAuth = 'api/auth';

  //아파트 조회
  static const String getApartment = 'api/apartment';

  static Future<bool> checkApartment(String value) async {
    final url = Uri.parse('$baseurl/$getApartment');
    final response = await http.get(url);

    final responseData = jsonDecode(response.body);
    final data = responseData['data'][0] as List<dynamic>;

    final apartment = data.firstWhere(
      (item) => item['name'] == value,
      orElse: () => null,
    );

    if (apartment != null) {
      final apartmentID = apartment['id'] as int;
      return true;
    } else {
      return false;
    }
  }

  static Future<void> login(
    int apartmentID,
    String dong,
    String ho,
    String name,
    String loginCode,
  ) async {
    final url = Uri.parse('$baseurl/$postAuth');

    var requestBody = jsonEncode({
      'apartmentID': apartmentID,
      'dong': dong,
      'ho': ho,
      'name': name,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print('Logged in successfully: $responseBody');
    } else {
      print('Login failed with status code: ${response.statusCode}');
    }
  }
}
