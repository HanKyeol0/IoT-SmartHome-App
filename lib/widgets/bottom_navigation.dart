import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';
import '../bell/bell.dart';
import '../door/door01.dart';
import '../parking/parking01.dart';
import '../setting/setting01.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final screens = [
    const Door01(),
    const Parking(),
    const Bell(),
    const Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.door_sliding_outlined,
                ),
                label: '공동현관'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.directions_car_filled_outlined,
                ),
                label: '주차위치'),
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
          currentIndex: _selectedIndex,
          selectedItemColor: bColor,
          unselectedItemColor: wColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
