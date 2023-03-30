import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/luxrobo_logo1.png'),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "필요한 정보를 불러들이고 있습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff757575),
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
