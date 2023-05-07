import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';
import '../widgets/button.dart';

class AccessAuthority extends StatefulWidget {
  const AccessAuthority({super.key});

  @override
  State<AccessAuthority> createState() => _AccessAuthorityState();
}

class _AccessAuthorityState extends State<AccessAuthority> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3E3E3E),
              borderRadius: BorderRadius.circular(7),
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(30),
            child: const Column(
              children: [
                Text(
                  '액세스 권한 설정',
                  style: TextStyle(
                    color: wColor,
                    fontSize: 18,
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "공동 현관문 출입, 주차 위치 저장 기능 등 기타 저장 기능을 위한 블루투스 위치 정보의 액세스 권한 설정이 반드시 필요합니다.",
                  style: TextStyle(
                    color: wColor,
                    fontSize: 14,
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '취소',
                      bgColor: grey,
                      textColor: wColor,
                      buttonWidth: 142.5,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: 142.5,
                      buttonHeight: 46,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showSecondPopup(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF282828),
    );
  }

  Future<void> _accessAuthority2(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('액세스 권한'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  _accessAuthority3(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: const Text('항상 허용'),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  _accessAuthority3(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: const Text('항상 허용'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
