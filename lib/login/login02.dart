import 'package:flutter/material.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/navigation.dart';
import 'package:luxrobo/services/api_service.dart';
import '../widgets/field.dart';

class Login02 extends StatefulWidget {
  const Login02({super.key});

  @override
  State<Login02> createState() => _Login02State();
}

class _Login02State extends State<Login02> {
  bool isTextEmpty1 = true;
  bool isTextEmpty2 = true;
  bool isTextEmpty3 = true;
  bool isTextEmpty4 = true;
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController textEditingController4 = TextEditingController();

  @override
  void initState() {
    super.initState();

    isTextEmpty1 = textEditingController1.text.isEmpty;
    isTextEmpty2 = textEditingController2.text.isEmpty;
    isTextEmpty3 = textEditingController3.text.isEmpty;
    isTextEmpty4 = textEditingController4.text.isEmpty;
  }

  void onText1(String value) {
    setState(() {
      isTextEmpty1 = value.isEmpty;
    });
  }

  void onText2(String value) {
    setState(() {
      isTextEmpty2 = value.isEmpty;
    });
  }

  void onText3(String value) {
    setState(() {
      isTextEmpty3 = value.isEmpty;
    });
  }

  void onText4(String value) {
    setState(() {
      isTextEmpty4 = value.isEmpty;
    });
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputField(
                      placeholder: '아파트 동을 입력해주세요.',
                      onTextChanged: onText1,
                      textEditingController: textEditingController1,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputField(
                      placeholder: '아파트 호수를 입력해주세요.',
                      onTextChanged: onText2,
                      textEditingController: textEditingController2,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputField(
                      placeholder: '이름을 입력해주세요.',
                      onTextChanged: onText4,
                      textEditingController: textEditingController3,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputField(
                      placeholder: '인증번호를 입력해주세요.',
                      onTextChanged: onText3,
                      textEditingController: textEditingController4,
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
            buttonColor: (!isTextEmpty1 &&
                    !isTextEmpty2 &&
                    !isTextEmpty3 &&
                    !isTextEmpty4)
                ? bColor
                : grey,
            textColor:
                (isTextEmpty1 || isTextEmpty2 || isTextEmpty3 || isTextEmpty4)
                    ? lightGrey
                    : black,
            isClickable:
                !(isTextEmpty1 || isTextEmpty2 || isTextEmpty3 || isTextEmpty4),
            onPressed: () {
              ApiService.login(
                1,
                textEditingController1.text,
                textEditingController2.text,
                textEditingController3.text,
                textEditingController4.text,
              ).then((_) {
                Navigator.pushNamed(context, '/door01');
              });
            },
          ),
        ],
      ),
      backgroundColor: black,
    );
  }
}
