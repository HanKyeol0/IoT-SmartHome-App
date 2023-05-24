import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';

class Door02 extends StatefulWidget {
  const Door02({super.key});

  @override
  State<Door02> createState() => _Door02State();
}

class _Door02State extends State<Door02> {
  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 0,
      body: Column(
        children: [
          const SizedBox(height: 90),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                GoBack(
                  onPressed: () => Navigator.pushNamed(context, '/door01'),
                ),
                const SizedBox(width: 15),
                Text(
                  '출입기록',
                  style: titleText(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 29),
        ],
      ),
    );
  }
}
