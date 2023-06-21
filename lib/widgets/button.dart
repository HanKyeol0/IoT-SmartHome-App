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

class RoundLoginButton extends StatefulWidget {
  final Color buttonColor;
  final Color textColor;
  final bool isClickable;
  final VoidCallback onPressed;

  const RoundLoginButton({
    super.key,
    required this.buttonColor,
    required this.textColor,
    this.isClickable = false,
    required this.onPressed,
  });

  @override
  State<RoundLoginButton> createState() => _RoundLoginButtonState();
}

class _RoundLoginButtonState extends State<RoundLoginButton> {
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
              '로그인',
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

class AutoAccessToggle extends StatefulWidget {
  const AutoAccessToggle({super.key});

  @override
  State<AutoAccessToggle> createState() => _AutoAccessToggleState();
}

class _AutoAccessToggleState extends State<AutoAccessToggle> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
        });
      },
      child: Container(
        width: 45,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: _value ? bColor : lightGrey,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              left: _value ? 20.0 : 0.0,
              right: _value ? 0.0 : 20.0,
              top: 3.2,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _value = !_value;
                  });
                },
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _value ? thickBlue : black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeeMoreButton extends StatefulWidget {
  const SeeMoreButton({
    super.key,
  });

  @override
  State<SeeMoreButton> createState() => _SeeMoreButtonState();
}

class _SeeMoreButtonState extends State<SeeMoreButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/door02'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 58,
        height: 23,
        decoration: BoxDecoration(
          color: bColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            '더보기',
            style: TextStyle(
              fontSize: 12,
              color: black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class GateAccess extends StatelessWidget {
  final bool isDetected;

  const GateAccess({
    super.key,
    required this.isDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            //padding: const EdgeInsets.all(33.5),
            height: 118,
            width: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDetected ? bColor : lightGrey,
              ),
            ),
            child: Icon(
              isDetected ? Icons.door_sliding_outlined : Icons.door_sliding,
              color: isDetected ? bColor : lightGrey,
              size: 51,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isDetected ? '터치해서 현관문 출입' : '출입문이 감지되지 않습니다.',
            style: fieldTitle(
              fontSize: 16,
              color: isDetected ? wColor : lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class TouchParking extends StatelessWidget {
  const TouchParking({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            //padding: const EdgeInsets.all(33.5),
            height: 118,
            width: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: bColor,
              ),
            ),
            child: const Icon(
              Icons.local_parking_rounded,
              color: bColor,
              size: 51,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '터치해서 주차하기',
            style: fieldTitle(
              fontSize: 16,
              color: wColor,
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyBell extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyBell({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              //padding: const EdgeInsets.all(33.5),
              height: 118,
              width: 118,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: bColor,
                ),
              ),
              child: const Icon(
                Icons.notification_important,
                color: bColor,
                size: 51,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '터치해서 비상벨 울리기',
              style: fieldTitle(
                fontSize: 16,
                color: wColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoBack extends StatelessWidget {
  final VoidCallback onPressed;

  const GoBack({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 26,
        width: 26,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: bColor,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 15,
          color: black,
        ),
      ),
    );
  }
}
