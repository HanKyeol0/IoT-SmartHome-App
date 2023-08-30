import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/services/api_service.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/field.dart';

import '../ble_platform_channel.dart';

class Parking extends StatefulWidget {
  const Parking({super.key});

  @override
  State<Parking> createState() => _ParkingState();
}

class BleDevice {
  String deviceId;
  String manufacturerSpecificData;
  int rssi;

  BleDevice({
    required this.deviceId,
    required this.manufacturerSpecificData,
    required this.rssi,
  });

  @override
  String toString() {
    return 'BleDevice { deviceId: $deviceId, manufacturerSpecificData: $manufacturerSpecificData, rssi: $rssi }';
  }
}

class _ParkingState extends State<Parking> with TickerProviderStateMixin {
  TextEditingController parkingCarController = TextEditingController();
  TextEditingController preferredParkingLotController = TextEditingController();
  bool isCarTextEmpty = true;
  bool isParkingLotTextEmpty = true;
  bool dataLoaded = false;
  List<BleDevice> devices = [];
  StreamSubscription<List<ScanResult>>? scanSubscription;
  int? apartmentID = GlobalData().getApartmentID;
  UserData? userData = GlobalData().userData;
  String? cctvId;

  Future<List<CarList>?> cars = ApiService.getUserCar();

  Future<List<ParkingLotList>?> lots = ApiService.getParkingLot();

  final Future<ParkingPlace> parkingPlace = ApiService.getParkingPlaceMap();

  final Future<PreferredLocation> userLocation =
      ApiService.getPreferredLocation();

  late TabController tabController;

  GlobalData globalData = GlobalData();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    loadCarList();
    loadParkingLotList();
    findNearestCCTV();
    loadCurrentCar();
    Future.delayed(Duration(seconds: 5), () {
      print('hello this is cctvID : $cctvId');
    });
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

  Future<List<Map<int, String>>> loadParkingLotList() async {
    final fetchedLots = await lots;
    List<Map<int, String>> parkingLotList = [];
    if (fetchedLots != null) {
      for (var lot in fetchedLots) {
        final userLot = lot.parkinglot;
        parkingLotList.add(userLot);
      }
    }
    return parkingLotList;
  }

  Future<String> loadCurrentCar() async {
    String carValue = await ApiService.getUserCurrentCar();

    if (carValue == '1') {
      return '등록된 차량이 없습니다.';
    } else if (carValue == '2') {
      return '차량 조회 실패 (네트워크 오류)';
    } else if (carValue == '3') {
      return '유저 정보 조회 실패';
    } else {
      return carValue;
    }
  }

  Future<String?> findNearestCCTV() async {
    await FlutterBluePlus.stopScan();

    int maxRssi = -999; // a large negative value to compare with actual RSSI
    BleDevice? maxRssiDevice;

    scanSubscription?.cancel();

    scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        //print(result);
        result.advertisementData.manufacturerData
            .forEach((id, manufacturerSpecificData) {
          var hexData = manufacturerSpecificData
              .map((data) => data.toRadixString(16).padLeft(2, '0'))
              .join();
          if (hexData.contains("4c4354")) {
            // Lux device code
            if (result.rssi > maxRssi) {
              // only store the device if its RSSI is greater than the current max
              maxRssi = result.rssi;
              //print(id);
              maxRssiDevice = BleDevice(
                  deviceId: "${result.device.remoteId}",
                  manufacturerSpecificData: hexData,
                  rssi: result.rssi);
            }
          }
        });
      }
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 3))
        .then((_) async {
      if (maxRssiDevice != null) {
        print('here is the device: $maxRssiDevice');
        final deviceIdString =
            maxRssiDevice!.manufacturerSpecificData.substring(0, 10);
        setState(() {
          cctvId = deviceIdString.replaceAll(":", "");
        });
      } else {
        // ignore: avoid_print
        print("No device found");
      }
    });
    return null;
  }

  void parkingAdvertising(cctvId) {
    if (userData == null) {
      // ignore: avoid_print
      print('User data is not set - mac address');
    } else {
      print('here is the user mac: ${userData!.mac}');

      BLEPlatformChannel.parkingAdvertising(userData!.mac, cctvId);
      print('parking test advertising in bell page');
      print('start');

      Future.delayed(Duration(seconds: 5), () {
        BLEPlatformChannel.stopAdvertising();
        print('end');
      });
    }
  }

  void cctvDetectionFailed(BuildContext context) {
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
                  'CCTV BLE가 감지되지 않습니다.',
                  style: titleText(),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
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

  Future<void> updateCurrentCar(String currentCar, BuildContext context) async {
    try {
      final int updateResult = await ApiService.putUserCurrentCar(currentCar);

      Navigator.of(context).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (updateResult == 1) {
          currentCarUpdateSucceeded(context);
        } else if (updateResult == 2) {
          unstableNetwork(context); // Update this function similarly
        } else if (updateResult == 3) {
          userInfoAccessFailed(context); // Update this function similarly
        }
      });
    } catch (e) {
      print("Error updating car: $e");
    }
  }

  void currentCarUpdateSucceeded(BuildContext context) {
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
                  '현재 차량 등록을 성공했습니다.',
                  style: titleText(),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
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

  void unstableNetwork(BuildContext context) {
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
                  '네트워크가 불안정합니다.',
                  style: titleText(),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
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

  void userInfoAccessFailed(BuildContext context) {
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
                  '유저 정보 조회 실패',
                  style: titleText(),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
                      buttonHeight: 46,
                      onPressed: () => Navigator.of(context).pop(),
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

  void registerCurrentCar(BuildContext context) {
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
                  '현재 차량으로 등록하시겠습니까?',
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
                        onPressed: () => updateCurrentCar(
                            parkingCarController.text, context),
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

  String formatDateTime(DateTime dateTime) {
    String year = DateFormat('y').format(dateTime);
    String month = DateFormat('MM').format(dateTime);
    String day = DateFormat('dd').format(dateTime);
    String hour = DateFormat('HH').format(dateTime);
    String minute = DateFormat('mm').format(dateTime);

    return "${year.substring(2)}년 ${month}월 ${day}일 ${hour}시 ${minute}분";
  }

  @override
  Widget build(BuildContext context) {
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
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
                            FutureBuilder<List<dynamic>>(
                              future: Future.wait(
                                  [loadCarList(), loadCurrentCar()]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    color: bColor,
                                  ));
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                List<String> loadedCarList =
                                    List<String>.from(snapshot.data![0]);
                                String currentCarValue = snapshot.data![1];
                                return CarInput(
                                  items: loadedCarList,
                                  placeholder: currentCarValue,
                                  onTextChanged: onCarChanged,
                                  textEditingController: parkingCarController,
                                  onItemSelected: registerCurrentCar,
                                  placeholderColor: wColor,
                                );
                              },
                            ),
                            const SizedBox(height: 74),
                            TouchParking(onPressed: () {
                              if (cctvId != null) {
                                print('cctv found');
                                parkingAdvertising(cctvId);
                                print(cctvId);
                              } else {
                                print('cctv not found');
                                cctvDetectionFailed(context);
                              }
                            }),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //위치 확인 tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
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
                        FutureBuilder<String?>(
                          future: loadCurrentCar(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return InfoField(value: snapshot.data!);
                            } else {
                              return InfoField(value: '주차 차량 조회 실패');
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '차량 위치',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: FutureBuilder<ParkingPlace>(
                            future: parkingPlace,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(color: bColor);
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return Stack(
                                  children: <Widget>[
                                    Image.network(
                                      snapshot.data!.mapImage,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        print(
                                            'Error loading image: $exception');
                                        return InfoField(value: '주차 위치 조회 실패');
                                      },
                                    ),
                                    Positioned(
                                      top: snapshot.data!.upperLeftY.toDouble(),
                                      left:
                                          snapshot.data!.upperLeftX.toDouble(),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.red,
                                          ),
                                        ),
                                        child: Container(
                                          width: (snapshot.data!.lowRightX -
                                                  snapshot.data!.upperLeftX)
                                              .toDouble(),
                                          height: (snapshot.data!.upperLeftY -
                                                  snapshot.data!.lowRightY)
                                              .toDouble(),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return InfoField(value: '주차 위치 조회 실패');
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<ParkingPlace>(
                          future: parkingPlace,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              if (snapshot.data!.place == 0 ||
                                  snapshot.data!.place == 1) {
                                return SizedBox();
                              } else {
                                return InfoField(
                                  value: snapshot.data!.place,
                                );
                              }
                            } else {
                              return InfoField(value: '주차 위치 조회 실패');
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '주차 시간',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<ParkingPlace>(
                          future: parkingPlace,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              if (snapshot.data!.place == 0 ||
                                  snapshot.data!.place == 1) {
                                return InfoField(value: '주차 시간 조회 실패');
                              } else {
                                return InfoField(
                                  value: formatDateTime(snapshot.data!.time),
                                );
                              }
                            } else {
                              return InfoField(value: '주차 시간 조회 실패');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                //선호 구역 tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
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
                        FutureBuilder<List<dynamic>>(
                            future: Future.wait([
                              userLocation,
                              loadParkingLotList(),
                            ]),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<dynamic>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: bColor,
                                  ),
                                );
                              }
                              PreferredLocation userParkingLot =
                                  snapshot.data![0];
                              List<Map<int, String>> parkingLotList =
                                  List<Map<int, String>>.from(
                                      snapshot.data![1]);
                              return PreferredCarInput(
                                placeholder: userParkingLot.place,
                                items: parkingLotList,
                                textEditingController:
                                    preferredParkingLotController,
                                onTextChanged: onParkingLotChanged,
                                placeholderColor: wColor,
                              );
                            }),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '선호구역',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
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
/*
  Widget build(BuildContext context) {
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
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
                            const SizedBox(height: 74),
                            TouchParking(onPressed: () {
                              if (cctvId != null) {
                                print('cctv found');
                                parkingAdvertising(cctvId);
                                print(cctvId);
                              } else {
                                print('cctv not found');
                                cctvDetectionFailed(context);
                              }
                            }),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //위치 확인 tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '차량 위치',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        FutureBuilder<ParkingPlace>(
                          future: parkingPlace,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              if (snapshot.data!.place == 0 ||
                                  snapshot.data!.place == 1) {
                                return SizedBox();
                              } else {
                                return InfoField(
                                  value: snapshot.data!.place,
                                );
                              }
                            } else {
                              return InfoField(value: '주차 위치 조회 실패');
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '주차 시간',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                //선호 구역 tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '선호구역',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
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
*/

/*
@override
  Widget build(BuildContext context) {
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
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
                            FutureBuilder<List<dynamic>>(
                              future: Future.wait(
                                  [loadCarList(), loadCurrentCar()]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    color: bColor,
                                  ));
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                List<String> loadedCarList =
                                    List<String>.from(snapshot.data![0]);
                                String currentCarValue = snapshot.data![1];
                                return CarInput(
                                  items: loadedCarList,
                                  placeholder: currentCarValue,
                                  onTextChanged: onCarChanged,
                                  textEditingController: parkingCarController,
                                  onItemSelected: registerCurrentCar,
                                  placeholderColor: wColor,
                                );
                              },
                            ),
                            const SizedBox(height: 74),
                            TouchParking(onPressed: () {
                              if (cctvId != null) {
                                print('cctv found');
                                parkingAdvertising(cctvId);
                                print(cctvId);
                              } else {
                                print('cctv not found');
                                cctvDetectionFailed(context);
                              }
                            }),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //위치 확인 tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
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
                        FutureBuilder<String?>(
                          future: loadCurrentCar(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return InfoField(value: snapshot.data!);
                            } else {
                              return InfoField(value: '주차 차량 조회 실패');
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '차량 위치',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<ParkingPlace>(
                          future: parkingPlace,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return Stack(
                                children: <Widget>[
                                  Image.network(
                                    snapshot.data!.mapImage,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      print('Error loading image: $exception');
                                      return InfoField(value: '주차 위치 조회 실패');
                                    },
                                  ),
                                  Positioned(
                                    top: snapshot.data!.upperLeftY.toDouble(),
                                    left: snapshot.data!.upperLeftX.toDouble(),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.red,
                                        ),
                                      ),
                                      child: Container(
                                        width: (snapshot.data!.lowRightX -
                                                snapshot.data!.upperLeftX)
                                            .toDouble(),
                                        height: (snapshot.data!.upperLeftY -
                                                snapshot.data!.lowRightY)
                                            .toDouble(),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return InfoField(value: '주차 위치 조회 실패');
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<ParkingPlace>(
                          future: parkingPlace,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              if (snapshot.data!.place == 0 ||
                                  snapshot.data!.place == 1) {
                                return SizedBox();
                              } else {
                                return InfoField(
                                  value: snapshot.data!.place,
                                );
                              }
                            } else {
                              return InfoField(value: '주차 위치 조회 실패');
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '주차 시간',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<ParkingPlace>(
                          future: parkingPlace,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              if (snapshot.data!.place == 0 ||
                                  snapshot.data!.place == 1) {
                                return InfoField(value: '주차 시간 조회 실패');
                              } else {
                                return InfoField(
                                  value: formatDateTime(snapshot.data!.time),
                                );
                              }
                            } else {
                              return InfoField(value: '주차 시간 조회 실패');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                //선호 구역 tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
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
                        FutureBuilder<List<dynamic>>(
                            future: Future.wait([
                              userLocation,
                              loadParkingLotList(),
                            ]),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<dynamic>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: bColor,
                                  ),
                                );
                              }
                              PreferredLocation userParkingLot =
                                  snapshot.data![0];
                              List<Map<int, String>> parkingLotList =
                                  List<Map<int, String>>.from(
                                      snapshot.data![1]);
                              return PreferredCarInput(
                                placeholder: userParkingLot.place,
                                items: parkingLotList,
                                textEditingController:
                                    preferredParkingLotController,
                                onTextChanged: onParkingLotChanged,
                                placeholderColor: wColor,
                              );
                            }),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '선호구역',
                            style: fieldTitle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<PreferredLocation>(
                          future: userLocation,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(color: bColor);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return Image.network(
                                snapshot.data!.mapImage,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  print('Error loading image: $exception');
                                  return InfoField(value: '선호구역 조회 실패');
                                },
                              );
                            } else {
                              return InfoField(value: '선호구역 조회 실패');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  */