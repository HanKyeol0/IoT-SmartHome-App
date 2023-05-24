import 'package:flutter/material.dart';
import 'package:luxrobo_publish/main.dart';
import 'package:luxrobo_publish/styles.dart';
import 'package:luxrobo_publish/widgets/button.dart';
import 'package:luxrobo_publish/widgets/field.dart';

class Setting02 extends StatefulWidget {
  const Setting02({Key? key}) : super(key: key);

  @override
  State<Setting02> createState() => _Setting02State();
}

class _Setting02State extends State<Setting02> {
  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 3,
      body: Column(
        children: [
          const SizedBox(height: 91),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    GoBack(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/setting01'),
                    ),
                    const SizedBox(width: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '차량 번호 등록',
                        style: titleText(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 52),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '차량 번호',
                    style: fieldTitle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                const InfoField(value: '직접 입력 가능한지? 그리고 등록 버튼 만들기'),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '현재 등록된 차량',
                    style: fieldTitle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
