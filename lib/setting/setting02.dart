import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_service.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/field.dart';
import 'package:luxrobo/services/api_data.dart';

class Setting02 extends StatefulWidget {
  const Setting02({Key? key}) : super(key: key);

  @override
  State<Setting02> createState() => _Setting02State();
}

class _Setting02State extends State<Setting02> {
  final Future<List<CarList>?> cars = ApiService.getUserCar();

  GlobalData globalData = GlobalData();

  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 3,
      body: SingleChildScrollView(
        child: Column(
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
                  const CarRegisterField(),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '현재 등록된 차량',
                      style: fieldTitle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder<List<CarList>?>(
                          future: cars,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                shrinkWrap: true,
                                children: [
                                  for (var car in snapshot.data!)
                                    UserCar(
                                        carNumber: car.number,
                                        onPressed: () =>
                                            confirmCar(context, car)),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'error: ${snapshot.error}',
                                style: const TextStyle(color: wColor),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(color: bColor),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> confirmCar(BuildContext context, CarList car) {
    return showDialog(
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
                  '차량을 삭제하시겠습니까?',
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
                        onPressed: () async {
                          await ApiService.deleteUserCar(car.id);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        },
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
}
