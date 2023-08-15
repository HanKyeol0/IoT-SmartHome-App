import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/services/api_service.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/field.dart';

class Parking extends StatefulWidget {
  const Parking({super.key});

  @override
  State<Parking> createState() => _ParkingState();
}

class _ParkingState extends State<Parking> with TickerProviderStateMixin {
  TextEditingController parkingCarController = TextEditingController();
  TextEditingController preferredParkingLotController = TextEditingController();
  bool isCarTextEmpty = true;
  bool isParkingLotTextEmpty = true;
  bool dataLoaded = false;

  Future<List<CarList>?> cars = ApiService.getUserCar();
  List<String> carList = [];

  Future<List<ParkingLotList>?> lots = ApiService.getParkingLot();
  List<String> parkingLotList = [];
  //late String initialCar;

  late TabController tabController;

  GlobalData globalData = GlobalData();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    loadCarList();
    loadParkingLotList();
  }

  Future<List<String>> loadCarList() async {
    final fetchedCars = await cars;
    List<String> loadedCarList = [];
    if (fetchedCars != null) {
      for (var car in fetchedCars) {
        final userCar = car.number;
        loadedCarList.add(userCar);
      }
    }
    return loadedCarList;
  }

  Future<void> loadParkingLotList() async {
    final fetchedLots = await lots;
    if (fetchedLots != null) {
      for (var lot in fetchedLots) {
        final userLot = lot.parkingLot;
        parkingLotList.add(userLot);
      }
    }
  }

  @override
  void dispose() {
    parkingCarController.dispose();
    preferredParkingLotController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void onCarChanged(String value) {
    setState(() {
      isCarTextEmpty = value.isEmpty;
    });
  }

  void onParkingLotChanged(String value) {
    setState(() {
      isParkingLotTextEmpty = value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: loadCarList(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<String> loadedCarList = snapshot.data ?? [];
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
                      //위치 저장 tab
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
                              items: loadedCarList,
                              placeholder: loadedCarList.isNotEmpty
                                  ? loadedCarList[0]
                                  : "등록된 차량이 없습니다.",
                              onTextChanged: onCarChanged,
                              textEditingController: parkingCarController,
                              onItemSelected: showParkingLocationSavingDialog,
                            ),
                            const SizedBox(height: 74),
                            const Expanded(child: TouchParking()),
                          ],
                        ),
                      ),
                      //위치 확인 tab
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
                            const SizedBox(height: 10),
                            const InfoField(value: '22년 12월 29일 (수) 18시 02분'),
                          ],
                        ),
                      ),
                      //선호 구역 tab
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
                              items: const ['1단지 B1 주차장 1구역'], //parkingLotList,
                              textEditingController:
                                  preferredParkingLotController,
                              onTextChanged: onParkingLotChanged,
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '선호구역 선택',
                                style: fieldTitle(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const InfoField(
                                value: 'Preffered Car Location Map'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

void showParkingLocationSavingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: darkGrey,
        elevation: 0.0, // No shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '주차 위치를 저장하시겠습니까?',
                style: titleText(),
              ),
              const SizedBox(
                height: 39,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RoundButton(
                      text: '취소',
                      bgColor: grey,
                      textColor: wColor,
                      buttonWidth: MediaQuery.of(context).size.width * 0.4,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.4,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
