import 'package:flutter/material.dart';
import 'package:luxrobo/bell/bell.dart';
import 'package:luxrobo/parking/parking.dart';
import 'package:luxrobo/setting/setting01.dart';
import 'package:luxrobo/setting/setting02.dart';
import 'package:luxrobo/styles.dart';
import 'door/door01.dart';
import 'door/door02.dart';
import 'login/login01.dart';
import 'login/login02.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/parking',
      routes: {
        '/login01': (context) => const Login01(),
        '/login02': (context) => const Login02(),
        '/door01': (context) => const Door01(),
        '/door02': (context) => const Door02(),
        '/parking': (context) => const Parking(),
        '/bell': (context) => const Bell(),
        '/setting01': (context) => const Setting01(),
        '/setting02': (context) => const Setting02(),
      },
    );
  }
}

class LuxroboScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const LuxroboScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      backgroundColor: black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: black,
          selectedItemColor: bColor,
          unselectedItemColor: wColor,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.door_sliding_outlined),
              label: '공동현관',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_filled_outlined),
              label: '주차위치',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications_outlined,
                ),
                label: '비상벨'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                ),
                label: '설정'),
          ],
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/door01');
                break;
              case 1:
                Navigator.pushNamed(context, '/parking');
                break;
              case 2:
                Navigator.pushNamed(context, '/bell');
                break;
              case 3:
                Navigator.pushNamed(context, '/setting01');
                break;
            }
          },
        ),
      ),
    );
  }
}
