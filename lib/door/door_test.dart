import 'package:flutter/material.dart';

class DoorTest extends StatelessWidget {
  const DoorTest({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoorTest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
