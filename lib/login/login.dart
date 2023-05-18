import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';
import '../widgets/button.dart';
import '../widgets/field.dart';
import '../widgets/navigation.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 111),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '로그인',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 21,
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      CircleNav(
                        text: '1',
                        bgColor: bColor,
                        textColor: black,
                      ),
                      SizedBox(width: 7),
                      CircleNav(
                        text: '2',
                        bgColor: grey,
                        textColor: lightGrey,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 10,
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    Text(
                      '단지 입력',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Expanded(
            child: Column(
              children: [
                DropdownInput(
                  placeholder: '아파트 명을 입력해주세요.',
                  items: [
                    'A',
                    'B',
                    'C',
                  ],
                  searchIconOn: 'assets/searchIconOn.png',
                  searchIconOff: 'assets/searchIconOff.png',
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Expanded(child: Container()),
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlueCheckbox(),
                      SizedBox(width: 11),
                      Text(
                        '내용 저장',
                        style: TextStyle(
                          fontFamily: 'luxFont',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 25,
            right: 25,
            bottom: 30,
            child: RoundNextButton(),
          ),
        ],
      ),
      backgroundColor: black,
    );
  }
}
