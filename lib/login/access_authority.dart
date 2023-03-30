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
      body: Center(
        child: Container(
          color: Colors.grey,
          child: const Column(
            children: [
              Text('액세스 권한 설정.'),
              Text(
                  "공동 현관문 출입, 주차 위치 저장 기능 등 기타 저장 기능을 위한 블루투스 위치 정보의 액세스 권한 설정이 반드시 필요합니다.")
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF3E3E3E),
    );
  }
}
