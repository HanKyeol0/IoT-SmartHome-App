import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final double buttonWidth;
  final double buttonHeight;
  final VoidCallback onPressed;

  const RoundButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _
}
