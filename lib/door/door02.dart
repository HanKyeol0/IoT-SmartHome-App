import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/services/api_data.dart';
import 'package:luxrobo/services/api_service.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';
import 'package:luxrobo/widgets/field.dart';

class Door02 extends StatefulWidget {
  const Door02({super.key});

  @override
  State<Door02> createState() => _Door02State();
}

class _Door02State extends State<Door02> {
  final Future<List<AccessLogList>?> logs = ApiService.getAccessLogs();
  GlobalData globalData = GlobalData();

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List<AccessLogList>?>(
                    future: logs,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var log = snapshot.data![index];
                            return AccessLog(
                              bgColor: grey,
                              iconBoxColor: darkGrey,
                              isKey: log.type == "smartkey" ? true : false,
                              accessTime: log.time,
                              floor: log.floor,
                              label: log.label,
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'error: ${snapshot.error}',
                          style: const TextStyle(color: wColor),
                        );
                      } else {
                        return const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(color: bColor),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
