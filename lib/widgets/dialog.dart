import 'package:flutter/material.dart';
import 'package:luxrobo/widgets/button.dart';
import '../styles.dart';

void unstableNetwork(BuildContext context) {
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
                '네트워크 상태가 불안정합니다. 잠시 후 다시 시도해주세요.',
                style: contentText(),
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
