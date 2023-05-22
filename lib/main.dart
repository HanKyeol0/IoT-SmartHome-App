import 'package:flutter/material.dart';
import 'door/door01.dart';
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
      initialRoute: '/Door01',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login01':
            return MaterialPageRoute(builder: (_) => const Login01());
          case '/login02':
            return MaterialPageRoute(builder: (_) => const Login02());
          case '/Door01':
            return MaterialPageRoute(builder: (_) => const Door01());
          default:
            return null;
        }
      },
    );
  }
}
