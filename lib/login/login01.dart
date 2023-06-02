import 'package:flutter/material.dart';
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
    final bool isValid = await ApiService.checkApartment(value);

    print(isValid);

    if (isValid) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/login02');
    }
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
