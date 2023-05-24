import 'package:flutter/material.dart';
import 'package:luxrobo/main.dart';
import 'package:luxrobo/styles.dart';
import 'package:luxrobo/widgets/button.dart';

class Setting01 extends StatefulWidget {
  const Setting01({Key? key}) : super(key: key);

  @override
  State<Setting01> createState() => _Setting01State();
}

class _Setting01State extends State<Setting01> {
  @override
  Widget build(BuildContext context) {
    return LuxroboScaffold(
      currentIndex: 3,
      body: Column(
        children: [
          const SizedBox(height: 91),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '설정',
                    style: titleText(),
                  ),
                ),
                const SizedBox(height: 52),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '정보등록',
                    style: fieldTitle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/setting02',
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: darkGrey,
                        width: 1.5,
                      ),
                      color: grey,
                    ),
                    height: 54,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '차량 번호 등록',
                          style: contentText(color: wColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '프로그램',
                    style: fieldTitle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: darkGrey,
                      width: 1.5,
                    ),
                    color: grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => showExitDialog(context),
                          child: SizedBox(
                            height: 54,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '앱 종료',
                                style: contentText(color: wColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: darkGrey,
                        ),
                        InkWell(
                          onTap: () => terminateAllFunctions(context),
                          child: SizedBox(
                            height: 54,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '앱 기능 모두 종료',
                                style: contentText(color: wColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: darkGrey,
                        ),
                        InkWell(
                          onTap: () => showLogoutDialog(context),
                          child: SizedBox(
                            height: 54,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '로그아웃',
                                style: contentText(color: wColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: darkGrey,
        elevation: 0.0, // No shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '앱을 종료하시겠습니까?',
                style: titleText(),
              ),
              const SizedBox(
                height: 39,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundButton(
                    text: '취소',
                    bgColor: grey,
                    textColor: wColor,
                    buttonWidth: 142.5,
                    buttonHeight: 46,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RoundButton(
                    text: '확인',
                    bgColor: bColor,
                    textColor: black,
                    buttonWidth: 142.5,
                    buttonHeight: 46,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void terminateAllFunctions(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: darkGrey,
        elevation: 0.0, // No shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 23),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '앱 기능 모두 종료',
                style: titleText(),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "모두 종료 시 현관 출입, 주차 위치, 비상벨 등의 설정이 모두 초기화되며 기능이 작동하지 않습니다.",
                style: contentText(
                  color: textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 39,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundButton(
                    text: '취소',
                    bgColor: grey,
                    textColor: wColor,
                    buttonWidth: 142.5,
                    buttonHeight: 46,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RoundButton(
                    text: '확인',
                    bgColor: bColor,
                    textColor: black,
                    buttonWidth: 142.5,
                    buttonHeight: 46,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: darkGrey,
        elevation: 0.0, // No shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '로그아웃 하시겠습니까?',
                style: titleText(),
              ),
              const SizedBox(
                height: 39,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundButton(
                    text: '취소',
                    bgColor: grey,
                    textColor: wColor,
                    buttonWidth: 142.5,
                    buttonHeight: 46,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RoundButton(
                    text: '확인',
                    bgColor: bColor,
                    textColor: black,
                    buttonWidth: 142.5,
                    buttonHeight: 46,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
