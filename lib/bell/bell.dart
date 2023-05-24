import 'package:flutter/material.dart';
import 'package:luxrobo_publish/main.dart';
import 'package:luxrobo_publish/styles.dart';
import 'package:luxrobo_publish/widgets/button.dart';

class Bell extends StatefulWidget {
  const Bell({Key? key}) : super(key: key);

  @override
  State<Bell> createState() => _Door01State();
}

class _Door01State extends State<Bell> {
  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 2,
      body: Column(
        children: [
          const SizedBox(height: 91),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '비상벨',
                style: titleText(),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EmergencyBell(),
                  const SizedBox(height: 50),
                  Text(
                    '비상 시 1초간 꾹 눌러주세요.',
                    style: emergencyBellContent(),
                  ),
                  Text(
                    '주변 CCTV로 연결됩니다.',
                    style: emergencyBellContent(),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
