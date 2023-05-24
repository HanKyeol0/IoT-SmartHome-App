import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/field.dart';

class Parking extends StatefulWidget {
  const Parking({super.key});

  @override
  State<Parking> createState() => _ParkingState();
}

class _ParkingState extends State<Parking> with TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  bool isTextEmpty = true;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void onTextChanged(String value) {
    setState(() {
      isTextEmpty = value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return LuxroboScaffold(
      currentIndex: 1,
      body: Column(
        children: [
          const SizedBox(height: 91),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                '주차 위치',
                style: titleText(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 46),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              child: Container(
                height: 41,
                decoration: BoxDecoration(
                  color: darkGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: bColor,
                  ),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(
                      child: Text(
                        '위치 저장',
                        style: TextStyle(
                          fontFamily: 'luxFont',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '위치 확인',
                        style: TextStyle(
                          fontFamily: 'luxFont',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '선호 구역',
                        style: TextStyle(
                          fontFamily: 'luxFont',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  labelColor: black,
                  unselectedLabelColor: lightGrey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '주차 차량',
                          style: fieldTitle(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CarInput(
                        items: const [
                          'A',
                          'B',
                        ],
                        placeholder: '주차하실 차량을 선택해주세요.',
                        onTextChanged: onTextChanged,
                        textEditingController: textEditingController,
                      ),
                      const SizedBox(height: 74),
                      const Expanded(child: TouchParking()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '주차 차량',
                          style: fieldTitle(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const InfoField(value: '123가 1234'),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '차량 위치',
                          style: fieldTitle(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const InfoField(value: 'Car Location Map'),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '차량 위치',
                          style: fieldTitle(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const InfoField(value: 'B2 F / 논현 하나빌 아파트 103동'),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '주차 시간',
                          style: fieldTitle(),
                        ),
                      ),
                      const InfoField(value: '22년 12월 29일 (수) 18시 02분'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '주차장 선택',
                          style: fieldTitle(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CarInput(
                          placeholder: '선호 주차장을 선택해주세요.',
                          items: const [
                            '1단지 101-103동 주차장',
                            '1단지 104-105동 주차장',
                            '2단지 201-103동 주차장',
                          ],
                          textEditingController: textEditingController,
                          onTextChanged: onTextChanged),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '선호구역 선택',
                          style: fieldTitle(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const InfoField(value: 'Preffered Car Location Map'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
