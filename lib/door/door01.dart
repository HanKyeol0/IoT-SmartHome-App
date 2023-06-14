import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/field.dart';
import '../widgets/button.dart';
import '../services/api_service.dart';

class Door01 extends StatefulWidget {
  const Door01({Key? key}) : super(key: key);

  @override
  State<Door01> createState() => _Door01State();
}

class _Door01State extends State<Door01> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    ApiService.getAccessLogs();
    //ApiService.getAccessLogs(
    //    '123asdasdpsajdgfkhdasfglajdfh', '123asdasdpsajdgfkhdasfglajdfh');
  }

  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 0,
      body: Stack(
        children: [
          Column(
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            '출입기록',
                            style: fieldTitle(),
                          ),
                          const Spacer(),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: SeeMoreButton(),
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
                    const GateAccess(
                      isDetected: true,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          const GateDetection(isDetected: true),
        ],
      ),
    );
  }
}
