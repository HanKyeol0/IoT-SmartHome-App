import 'package:flutter/material.dart';
import 'door/door01.dart';
import 'login/login01.dart';
import 'login/login02.dart';
import 'styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login01': (context) => const Login01(),
        '/login02': (context) => const Login02(),
        '/door01': (context) => const Door01(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Door01(),
    const Login01(),
    const Login02(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final screens = [
    const Door01(),
  ];

  void _onItemTapped(value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: black,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: black,
            elevation: 0.0,
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
      ),
    );
  }
}
