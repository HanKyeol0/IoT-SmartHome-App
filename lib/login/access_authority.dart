import 'package:flutter/material.dart';

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
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "공동 현관문 출입, 주차 위치 저장 기능 등 기타 저장 기능을 위한 블루투스 위치 정보의 액세스 권한 설정이 반드시 필요합니다.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Text(
                          '취소',
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '확인',
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF282828),
    );
  }
}
