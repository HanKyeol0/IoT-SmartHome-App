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
    if (await ApiService.login(
          widget.apartmentID!,
          dongController.text,
          hoController.text,
          nameController.text,
          loginCodeController.text,
        ) ==
        true) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/door01');
    } else {
      return null;
    }
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
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  //Login code entering field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputField(
                      placeholder: '인증번호를 입력해주세요.',
                      onTextChanged: onText3,
                      textEditingController: loginCodeController,
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
