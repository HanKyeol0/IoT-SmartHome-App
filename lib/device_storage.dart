import 'package:shared_preferences/shared_preferences.dart';

class LoginInfoService {
  static final keyDong = 'dong';
  static final keyHo = 'ho';
  static final keyName = 'name';
  static final keyLoginCode = 'loginCode';
  static final keySave = 'save';

  Future<void> saveLoginInfo({
    required String dong,
    required String ho,
    required String name,
    required String loginCode,
    required bool save,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyDong, dong);
    await prefs.setString(keyHo, ho);
    await prefs.setString(keyName, name);
    await prefs.setString(keyLoginCode, loginCode);
    await prefs.setBool(keySave, save);
  }

  Future<Map<String, dynamic>> retrieveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      keyDong: prefs.getString(keyDong),
      keyHo: prefs.getString(keyHo),
      keyName: prefs.getString(keyName),
      keyLoginCode: prefs.getString(keyLoginCode),
      keySave: prefs.getBool(keySave),
    };
  }
}

class ApartmentInfoService {
  static final keyApartment = 'apartment';
  static final keySave = 'save';

  Future<void> saveApartmentInfo({
    required String apartment,
    required bool save,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyApartment, apartment);
    await prefs.setBool(keySave, save);
  }

  Future<Map<String, dynamic>> retrieveApartmentInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      keyApartment: prefs.getString(keyApartment),
      keySave: prefs.getBool(keySave),
    };
  }
}
