import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    '로그인',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 21),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: bColor,
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Color(0xFF1C1C1C),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF262626),
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Color(0xFF767676),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
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
