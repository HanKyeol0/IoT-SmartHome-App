import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';

class Bell extends StatefulWidget {
  const Bell({Key? key}) : super(key: key);

  @override
  State<Bell> createState() => _Door01State();
}

class _Door01State extends State<Bell> {
  static const platform = MethodChannel('com.bell/value');

  // ignore: unused_field
  String _value = 'null';

  Future<void> _getNativeValue() async {
    String value;

    try {
      value = await platform.invokeMethod('getValue');
    } on PlatformException catch (e) {
      value = 'error message : ${e.message}';
    }

    setState(() {
      _value = value;
    });
  }

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
                  EmergencyBell(onPressed: _getNativeValue),
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
                    height: 50,
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
