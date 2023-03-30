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
            color: const Color(0xFF3E3E3E),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Container(
                  child: const Text(
                    '액세스 권한 설정',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Text(
                  "공동 현관문 출입, 주차 위치 저장 기능 등 기타 저장 기능을 위한 블루투스 위치 정보의 액세스 권한 설정이 반드시 필요합니다.",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF3F3F3F),
    );
  }
}
