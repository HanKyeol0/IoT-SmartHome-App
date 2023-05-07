import 'package:flutter/material.dart';

class CircleNav extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const CircleNav({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
