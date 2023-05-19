import 'package:flutter/material.dart';
import '../styles.dart';

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
    this.bgColor = grey,
    required this.textColor,
    this.buttonWidth = 140,
    this.buttonHeight = 140,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
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
      ),
    );
  }
}

class RoundNextButton extends StatefulWidget {
  final Color buttonColor;
  final Color textColor;
  final bool isClickable;
  final VoidCallback onPressed;

  const RoundNextButton({
    super.key,
    required this.buttonColor,
    required this.textColor,
    this.isClickable = false,
    required this.onPressed,
  });

  @override
  State<RoundNextButton> createState() => _RoundNextButtonState();
}

class _RoundNextButtonState extends State<RoundNextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isClickable ? widget.onPressed : null,
      borderRadius: BorderRadius.circular(30),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 54,
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              '다음',
              style: contentText(
                fontSize: 16,
                color: widget.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlueCheckbox extends StatefulWidget {
  const BlueCheckbox({super.key});

  @override
  State<BlueCheckbox> createState() => _BlueCheckboxState();
}

class _BlueCheckboxState extends State<BlueCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isChecked ? bColor : Colors.transparent,
          border: isChecked
              ? Border.all(
                  color: bColor,
                )
              : Border.all(color: lightGrey),
          borderRadius: BorderRadius.circular(2.0),
        ),
        padding: const EdgeInsets.only(bottom: 1.5),
        height: 18,
        width: 18,
        child: isChecked
            ? const Icon(
                Icons.check_outlined,
                color: black,
                size: 17,
                weight: 20.0,
              )
            : null,
      ),
    );
  }
}
