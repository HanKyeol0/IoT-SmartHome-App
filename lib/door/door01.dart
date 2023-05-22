import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';

import '../widgets/button.dart';

class Door01 extends StatefulWidget {
  const Door01({Key? key}) : super(key: key);

  @override
  State<Door01> createState() => _Door01State();
}

class _Door01State extends State<Door01> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 91),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  '공동현관',
                  style: titleText(fontSize: 21),
                ),
                Text(
                  '자동출입',
                  style: fieldTitle(fontSize: 14),
                ),
                SizedBox(
                  width: 45,
                  height: 26,
                  child: ToggleSwitch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: black,
    );
  }
}
