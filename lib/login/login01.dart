import 'package:flutter/material.dart';
import 'package:luxrobo/login/login02.dart';
import 'package:luxrobo/styles.dart';
import '../widgets/button.dart';
import '../widgets/field.dart';
import '../widgets/navigation.dart';
import '../services/api_service.dart';

class Login01 extends StatefulWidget {
  const Login01({Key? key}) : super(key: key);

  @override
  State<Login01> createState() => _Login01State();
}

class _Login01State extends State<Login01> {
  TextEditingController apartmentController = TextEditingController();
  bool isTextEmpty = true;
  bool isClickable = false;
  int? apartmentID;

  @override
  void dispose() {
    apartmentController.dispose();
    super.dispose();
  }

  void onTextChanged(String value) {
    setState(() {
      isTextEmpty = value.isEmpty;
    });
  }

  void onPressedNext() async {
    final value = apartmentController.text;
    final int? apartmentID = await ApiService.checkApartment(value);

    if (apartmentID == null) {
      // ignore: use_build_context_synchronously
      showApartmentNotFound(context);
    } else {
      setState(() {
        this.apartmentID = apartmentID;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login02(apartmentID: apartmentID),
        ),
      );
    }
  }

  void showApartmentNotFound(BuildContext context) {
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
                  '아파트 이름을 찾을 수 없습니다.',
                  style: contentText(
                    color: wColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 39,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      text: '확인',
                      bgColor: bColor,
                      textColor: black,
                      buttonWidth: MediaQuery.of(context).size.width * 0.3,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(height: 111),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '로그인',
                    style: titleText(fontSize: 21),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      CircleNav(
                        text: '1',
                        bgColor: bColor,
                        textColor: black,
                      ),
                      SizedBox(width: 7),
                      CircleNav(
                        text: '2',
                        bgColor: grey,
                        textColor: lightGrey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '단지 입력',
                      style: fieldTitle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //아파트 입력
          Expanded(
            child: Column(
              children: [
                DropdownInput(
                  placeholder: '아파트 명을 입력해주세요.',
                  items: const [
                    '럭스로보 아파트',
                    '아이아라 아파트',
                  ],
                  searchIconOn: 'assets/searchIconOn.png',
                  searchIconOff: 'assets/searchIconOff.png',
                  textEditingController: apartmentController,
                  onTextChanged: onTextChanged,
                ),
                const SizedBox(height: 11),
                //내용 저장
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            BlueCheckbox(),
                            SizedBox(width: 11),
                            Text(
                              '내용 저장',
                              style: TextStyle(
                                fontFamily: 'luxFont',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //move to BLE test page
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/bleTest',
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
                          'BLE test page',
                          style: contentText(color: wColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          RoundNextButton(
            buttonColor: isTextEmpty ? grey : bColor,
            textColor: isTextEmpty ? lightGrey : black,
            isClickable: !isTextEmpty,
            onPressed: onPressedNext,
          ),
        ],
      ),
      backgroundColor: black,
    );
  }
}
