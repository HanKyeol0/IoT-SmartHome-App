import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/navigation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../widgets/dialog.dart';
import '../widgets/field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luxrobo/services/api_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
//import 'package:platform_device_id/platform_device_id.dart';

class Login02 extends StatefulWidget {
  final int? apartmentID;

  const Login02({super.key, this.apartmentID});

  @override
  State<Login02> createState() => _Login02State();
}

class _Login02State extends State<Login02> {
  bool isDongEmpty = true;
  bool isHoEmpty = true;
  bool isNameEmpty = true;
  bool isLoginCodeEmpty = true;
  bool _isLoginCodeRight = true;
  TextEditingController dongController = TextEditingController();
  TextEditingController hoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController loginCodeController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    getDeviceUUID();

    isDongEmpty = dongController.text.isEmpty;
    isHoEmpty = hoController.text.isEmpty;
    isNameEmpty = nameController.text.isEmpty;
    isLoginCodeEmpty = loginCodeController.text.isEmpty;
  }

  void onText1(String value) {
    setState(() {
      isDongEmpty = value.isEmpty;
    });
  }

  void onText2(String value) {
    setState(() {
      isHoEmpty = value.isEmpty;
    });
  }

  void onText3(String value) {
    setState(() {
      isNameEmpty = value.isEmpty;
    });
  }

  void onText4(String value) {
    setState(() {
      isLoginCodeEmpty = value.isEmpty;
    });
  }

  // get mac address
  Future<String?> getWifiBSSID() async {
    final NetworkInfo info = NetworkInfo();
    final String? wifiBSSID = await info.getWifiBSSID();
    return wifiBSSID;
  }

  Future<String?> getDeviceUUID() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.deviceInfo;
      print('here is the device info hello): ${androidInfo.data}');
      return null;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      //print(iosInfo);
      return iosInfo.identifierForVendor;
    }
    return 'Unknown UUID';
  }

  Future<String?> getID() async {
    const MethodChannel _deviceID = MethodChannel('com.example.luxrobo');

    final Future<String?> uuid = _deviceID.invokeMethod<String?>('getId');
    print('here is the device UUID $uuid');
    return uuid;
  }

  //login function
  Future<UserData?> onPressedLogin() async {
    //final String? macAddress = await getWifiBSSID();
    final String? deviceId = await getDeviceUUID();
    //final String? deviceId = await getDeviceId();
    //final String? deviceId = await getID();

    final response = await http.post(
      Uri.parse('http://13.125.92.61:8080/api/auth'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'apartmentId': widget.apartmentID,
        'dong': dongController.text,
        'ho': hoController.text,
        'name': nameController.text,
        'loginCode': loginCodeController.text,
      }),
    );

    if (response.statusCode == 201) {
      final userData = UserData.fromJson(jsonDecode(response.body));
      GlobalData().setUserData(userData);
      print('hello hello here ${userData.mac}');

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/door01_android');

      return userData;
    } else if (response.statusCode == 400) {
      // ignore: avoid_print
      print('로그인 코드가 일치하지 않습니다.');
      setState(() {
        _isLoginCodeRight = false;
      });
      return null;
    } else if (response.statusCode == 404) {
      // ignore: use_build_context_synchronously
      showUserNotFound(context);
      return null;
    } else {
      // ignore: use_build_context_synchronously
      unstableNetwork(context);
      return null;
    }
  }

  Future<List<String>> saveToken(accessToken, refreshToken) async {
    // ignore: avoid_print
    print("$accessToken, $refreshToken");
    return [accessToken, refreshToken];
  }

  void showUserNotFound(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: darkGrey,
          elevation: 0.0, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '유저를 찾을 수 없습니다.',
                  style: contentText(),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void unstableNetwork(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: darkGrey,
          elevation: 0.0, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '네트워크 상태가 불안정합니다. 잠시 후 다시 시도해주세요.',
                  style: contentText(),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 111),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '로그인',
                      style: titleText(fontSize: 21),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        CircleNav(
                          text: '1',
                          bgColor: grey,
                          textColor: lightGrey,
                        ),
                        SizedBox(width: 7),
                        CircleNav(
                          text: '2',
                          bgColor: bColor,
                          textColor: black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '동 입력',
                                style: fieldTitle(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    //Dong entering field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: InputField(
                        placeholder: '아파트 동을 입력해주세요.',
                        onTextChanged: onText1,
                        textEditingController: dongController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '호수 입력',
                                style: fieldTitle(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    //Ho entering field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: InputField(
                        placeholder: '아파트 호수를 입력해주세요.',
                        onTextChanged: onText2,
                        textEditingController: hoController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '이름 입력',
                                style: fieldTitle(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    //Name entering field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: InputField(
                        placeholder: '이름을 입력해주세요.',
                        onTextChanged: onText4,
                        textEditingController: nameController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '로그인 코드 입력',
                                style: fieldTitle(),
                              ),
                              const SizedBox(width: 4),
                              Visibility(
                                  visible: !_isLoginCodeRight,
                                  child: const Icon(
                                    Icons.error_outline,
                                    size: 16,
                                    color: Color(0xFFFA1A1A),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    //Login code entering field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: LoginCodeInputField(
                        placeholder: '인증번호를 입력해주세요.',
                        onTextChanged: onText3,
                        textEditingController: loginCodeController,
                        isLoginCodeRight: _isLoginCodeRight,
                      ),
                    ),
                    const SizedBox(height: 5.5),
                    Visibility(
                      visible: !_isLoginCodeRight,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            '로그인 코드를 확인해주세요.',
                            style: TextStyle(
                              fontFamily: 'luxFont',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFFFA1A1A),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 32),
                          child: Row(
                            children: [
                              const BlueCheckbox(),
                              const SizedBox(width: 11),
                              Text(
                                '내용 저장',
                                style: contentText(color: wColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              const BlueCheckbox(),
                              const SizedBox(width: 11),
                              Text(
                                '자동 로그인',
                                style: contentText(color: wColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            RoundLoginButton(
              buttonColor: (!isDongEmpty &&
                      !isHoEmpty &&
                      !isNameEmpty &&
                      !isLoginCodeEmpty)
                  ? bColor
                  : grey,
              textColor:
                  (isDongEmpty || isHoEmpty || isNameEmpty || isLoginCodeEmpty)
                      ? lightGrey
                      : black,
              isClickable: !(isDongEmpty ||
                  isHoEmpty ||
                  isNameEmpty ||
                  isLoginCodeEmpty),
              onPressed: onPressedLogin,
            ),
          ],
        ),
        backgroundColor: black,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const MethodChannel _methodChannel = MethodChannel('deviceId');
  final uuid = _methodChannel.invokeMethod<String?>('getId');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UUID Example'),
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: _methodChannel.invokeMethod<String?>('getId'),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
