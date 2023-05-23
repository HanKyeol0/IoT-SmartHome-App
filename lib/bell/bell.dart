import 'package:flutter/material.dart';
import 'package:luxrobo_publish/styles.dart';
import '../widgets/button.dart';
import '../widgets/field.dart';
import '../widgets/navigation.dart';

class Bell extends StatefulWidget {
  const Bell({Key? key}) : super(key: key);

  @override
  State<Bell> createState() => _Login01State();
}

class _Login01State extends State<Bell> {
  TextEditingController textEditingController = TextEditingController();
  bool isTextEmpty = true;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void onTextChanged(String value) {
    setState(() {
      isTextEmpty = value.isEmpty;
    });
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
          Expanded(
            child: Column(
              children: [
                DropdownInput(
                  placeholder: '아파트 명을 입력해주세요.',
                  items: const [
                    'A',
                    'B',
                    'C',
                  ],
                  searchIconOn: 'assets/searchIconOn.png',
                  searchIconOff: 'assets/searchIconOff.png',
                  textEditingController: textEditingController,
                  onTextChanged: onTextChanged,
                ),
                const SizedBox(height: 11),
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
              ],
            ),
          ),
          RoundNextButton(
            buttonColor: isTextEmpty ? grey : bColor,
            textColor: isTextEmpty ? lightGrey : black,
            isClickable: !isTextEmpty,
            onPressed: () => Navigator.pushNamed(context, '/login02'),
          ),
        ],
      ),
      backgroundColor: black,
    );
  }
}
