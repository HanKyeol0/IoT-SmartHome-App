import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';
import '../widgets/button.dart';

class AccessAuthority extends StatefulWidget {
  const AccessAuthority({Key? key}) : super(key: key);

  @override
  State<AccessAuthority> createState() => _AccessAuthorityState();
}

class _AccessAuthorityState extends State<AccessAuthority> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _accessAuthority1(context));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> _accessAuthority1(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF2D2D2D),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Dialog(
              backgroundColor: dialogColor,
              elevation: 0.0, // No shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 23),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '액세스 권한 설정',
                      style: titleText(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "공동 현관문 출입, 주차 위치 저장 기능 등 기타 저장 기능을 위한 블루투스 위치 정보의 액세스 권한 설정이 반드시 필요합니다.",
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            _accessAuthority2(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _accessAuthority2(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF2D2D2D),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Dialog(
              backgroundColor: dialogColor,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '액세스 권한',
                      style: titleText(),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    SizedBox(
                      height: 53,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextButton(
                        child: Text(
                          '앱 사용 중에만 허용',
                          style: contentText(
                            color: textGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _accessAuthority3(context);
                        },
                      ),
                    ),
                    const Divider(
                      color: Color(0xFF767676),
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 53,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextButton(
                        child: Text(
                          '항상 허용',
                          style: contentText(
                            color: textGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _accessAuthority3(context);
                        },
                      ),
                    ),
                    const Divider(
                      color: Color(0xFF767676),
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 53,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextButton(
                        child: const Text(
                          '허용 안 함',
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 16,
                            fontFamily: 'luxFont',
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _accessAuthority3(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF2D2D2D),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Dialog(
              backgroundColor: dialogColor,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '근처 기기 액세스 권한',
                      style: titleText(),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    SizedBox(
                      height: 53,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextButton(
                        child: Text(
                          '앱 사용 중에만 허용',
                          style: contentText(
                            color: textGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                      ),
                    ),
                    const Divider(
                      color: Color(0xFF767676),
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 53,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextButton(
                        child: Text(
                          '항상 허용',
                          style: contentText(
                            color: textGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                      ),
                    ),
                    const Divider(
                      color: Color(0xFF767676),
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 53,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextButton(
                        child: Text(
                          '허용 안 함',
                          style: contentText(
                            color: textGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
