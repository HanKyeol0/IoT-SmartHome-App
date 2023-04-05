import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';

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
                    fontSize: 20,
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
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CancelButton(),
                    SizedBox(
                      width: 10,
                    ),
                    ConfirmButton()
                  ],
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

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 142.5,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Text(
          '취소',
          style: TextStyle(
            fontSize: 16,
            color: wColor,
          ),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 142.5,
      height: 46,
      decoration: BoxDecoration(
        color: bColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Center(
        child: Text(
          '확인',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
          ),
        ),
      ),
    );
  }
}
