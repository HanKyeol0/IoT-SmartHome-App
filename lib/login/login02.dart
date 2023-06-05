import 'package:flutter/material.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/navigation.dart';
import 'package:luxrobo/services/api_service.dart';
import '../widgets/field.dart';

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

  void onPressedLogin() async {
    int response = await ApiService.login(
      widget.apartmentID!,
      dongController.text,
      hoController.text,
      nameController.text,
      loginCodeController.text,
    );
    if (response == 0) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/door01');
    } else if (response == 1) {
      print('로그인 코드가 일치하지 않습니다.');
      setState(() {
        _isLoginCodeRight = false;
      });
    } else if (response == 2) {
      // ignore: use_build_context_synchronously
      showUserNotFound(context);
    } else if (response == 3) {
      unstableNetwork(context);
    }
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
    return Scaffold(
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
            isClickable:
                !(isDongEmpty || isHoEmpty || isNameEmpty || isLoginCodeEmpty),
            onPressed: onPressedLogin,
          ),
        ],
      ),
      backgroundColor: black,
    );
  }
}
