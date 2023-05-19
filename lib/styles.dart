import 'package:flutter/material.dart';

const Color wColor = Color(0xFFFFFFFF);
const Color bColor = Color(0xFF5AE5F7);
const Color black = Color(0xFF1C1C1C);
const Color grey = Color(0xFF262626);
const Color lightGrey = Color(0xFF767676);
const Color dialogColor = Color(0xFF3E3E3E);
const Color textGrey = Color(0xFFECF1F1);

TextStyle contentText(
    {FontWeight fontWeight = FontWeight.w700,
    double fontSize = 14,
    Color color = lightGrey}) {
  return TextStyle(
    fontFamily: 'luxFont',
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
    height: 1.5,
  );
}

TextStyle titleText({double fontSize = 18}) {
  return TextStyle(
    color: wColor,
    fontSize: fontSize,
    fontFamily: 'luxFont',
    fontWeight: FontWeight.w800,
  );
}

TextStyle fieldTitle() {
  return const TextStyle(
    fontFamily: 'luxFont',
    fontWeight: FontWeight.w700,
    color: wColor,
    fontSize: 15,
  );
}
