import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';
import '../widgets/navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 111,
          ),
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
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      CircleNav(
                        text: '1',
                        bgColor: bColor,
                        textColor: black,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      CircleNav(
                        text: '2',
                        bgColor: grey,
                        textColor: lightGrey,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20),
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
          )
        ],
      ),
      backgroundColor: const Color(0xFF1C1C1C),
    );
  }
}
