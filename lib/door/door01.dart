import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';
import 'package:luxrobo_publish/widgets/field.dart';
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
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Text(
                        '자동출입',
                        style: fieldTitle(fontSize: 14),
                      ),
                      const SizedBox(width: 7),
                      const AutoAccessToggle(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 51),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  '출입기록',
                  style: fieldTitle(),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: SeeMoreButton(
                    onPressed: () => Navigator.pushNamed(context, '/door01'),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          const AccessLog(
            bgColor: darkGrey,
            isPhone: true,
          ),
          const AccessLog(
            bgColor: darkGrey,
            isPhone: false,
          ),
          const AccessLog(
            bgColor: darkGrey,
            isPhone: true,
          ),
          const SizedBox(height: 60),
          const DoorAccess(
            isOpened: true,
          ),
        ],
      ),
      backgroundColor: black,
    );
  }
}
