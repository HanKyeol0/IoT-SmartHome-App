import 'package:flutter/material.dart';
import '../styles.dart';
import '../services/api_service.dart';

class DropdownInput extends StatefulWidget {
  final String placeholder;
  final List<String> items;
  final String searchIconOn;
  final String searchIconOff;
  final TextEditingController textEditingController;
  final Function(String) onTextChanged;
  final Function searchApartment;

  const DropdownInput({
    Key? key,
    required this.placeholder,
    required this.items,
    required this.searchIconOn,
    required this.searchIconOff,
    required this.textEditingController,
    required this.onTextChanged,
    required this.searchApartment,
  }) : super(key: key);

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? selectedValue;
  bool showDropdown = false;
  bool searchIconActivated = false;

  @override
  void initState() {
    super.initState();
    selectedValue = null;
  }

  void toggleDropdown() {
    setState(() {
      showDropdown = !showDropdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: (widget.textEditingController.text.isEmpty || !showDropdown)
            ? Border.all(color: darkGrey, width: 1)
            : Border.all(color: wColor, width: 1),
        color: grey,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: TextField(
              controller: widget.textEditingController,
              style: const TextStyle(color: wColor),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: contentText(color: lightGrey),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18.5,
                  horizontal: 15,
                ),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () async {
                    await widget.searchApartment();
                    setState(() {
                      toggleDropdown();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      !widget.textEditingController.text.isEmpty
                          //&&!showDropdown
                          ? widget.searchIconOff
                          : widget.searchIconOn,
                      width: 10,
                      height: 10,
                    ),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  widget.onTextChanged;
                  widget.searchApartment();
                  selectedValue = null; // Clear the selected value
                });
                widget.onTextChanged(value);
                if (value.isNotEmpty) {
                  setState(() {
                    showDropdown = true;
                  });
                  //null;
                } else {
                  setState(() {
                    showDropdown = false;
                  });
                }
              },
            ),
          ),
          Container(
            height: 0.5,
            color: showDropdown ? lightGrey : null,
          ),
          if (showDropdown)
            ListView.separated(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              shrinkWrap: true,
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const Divider(
                color: lightGrey,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                final item = widget.items[index];

                // Extract the search text and item text for easier access.
                final String searchText = widget.textEditingController.text;
                final String itemText = item;

                // Find the start and end indices of the searchText in the itemText.
                int startIndex = itemText.indexOf(searchText);
                int endIndex = startIndex + searchText.length;

                // Create TextSpans for segments before, within, and after the matched substring.
                List<TextSpan> textSpans = [];
                if (startIndex != -1) {
                  // Means we found a match
                  if (startIndex > 0) {
                    textSpans.add(TextSpan(
                        text: itemText.substring(0, startIndex),
                        style: contentText(color: lightGrey, fontSize: 16)));
                  }
                  textSpans.add(TextSpan(
                      text: itemText.substring(startIndex, endIndex),
                      style: contentText(color: wColor, fontSize: 16)));
                  if (endIndex < itemText.length) {
                    textSpans.add(TextSpan(
                        text: itemText.substring(endIndex),
                        style: contentText(color: lightGrey, fontSize: 16)));
                  }
                } else {
                  textSpans.add(TextSpan(
                      text: itemText,
                      style: contentText(color: lightGrey, fontSize: 16)));
                }
                return Container(
                  height: 56,
                  child: ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: textSpans,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedValue = item;
                        widget.textEditingController.text = item;
                        showDropdown = false;
                      });
                      widget.onTextChanged(item);
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class InputField extends StatefulWidget {
  final String placeholder;
  final Function(String) onTextChanged;
  final TextEditingController textEditingController;

  const InputField({
    super.key,
    required this.placeholder,
    required this.onTextChanged,
    required this.textEditingController,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: darkGrey, width: 1.5),
        color: grey,
      ),
      height: 58,
      child: TextField(
        controller: widget.textEditingController,
        style: contentText(color: wColor),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: contentText(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 19.5,
            horizontal: 15,
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          widget.onTextChanged(value);
        },
      ),
    );
  }
}

class LoginCodeInputField extends StatefulWidget {
  final String placeholder;
  final Function(String) onTextChanged;
  final TextEditingController textEditingController;
  final bool isLoginCodeRight;

  const LoginCodeInputField({
    super.key,
    required this.placeholder,
    required this.onTextChanged,
    required this.textEditingController,
    required this.isLoginCodeRight,
  });

  @override
  State<LoginCodeInputField> createState() => _LoginCodeInputFieldState();
}

class _LoginCodeInputFieldState extends State<LoginCodeInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: widget.isLoginCodeRight
            ? Border.all(color: darkGrey, width: 1.5)
            : Border.all(color: const Color(0xFFFA1A1A), width: 1.5),
        color: grey,
      ),
      height: 58,
      child: TextField(
        controller: widget.textEditingController,
        style: contentText(color: wColor),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: contentText(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 19.5,
            horizontal: 15,
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          widget.onTextChanged(value);
        },
      ),
    );
  }
}

class AccessLog extends StatelessWidget {
  final Color bgColor;
  final Color iconBoxColor;
  final bool isKey;
  final String accessTime;
  final String floor;
  final String label;

  const AccessLog({
    super.key,
    required this.isKey,
    required this.bgColor,
    required this.iconBoxColor,
    required this.accessTime,
    required this.floor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: iconBoxColor,
              ),
              child: Icon(
                isKey ? Icons.credit_card : Icons.phone_android_outlined,
                color: bColor,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 17,
                  bottom: 17,
                  right: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        right: 15,
                      ),
                      child: Text(
                        accessTime,
                        style: contentText(
                          color: wColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      width: 19,
                      color: lightGrey,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        '$floor-$label',
                        style: contentText(
                          color: wColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GateDetection extends StatefulWidget {
  final bool isDetected;

  const GateDetection({
    super.key,
    required this.isDetected,
  });

  @override
  State<GateDetection> createState() => _GateDetectionState();
}

class _GateDetectionState extends State<GateDetection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 20,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isDetected ? bColor : lightGrey,
              ),
              child: Center(
                child: SizedBox(
                  height: 18,
                  child: Image.asset('assets/doorDetection.png'),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              widget.isDetected ? '출입문 감지' : '출입문 감지 실패',
              style: contentText(
                color: wColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarInput extends StatefulWidget {
  final String placeholder;
  final List<dynamic> items;
  final TextEditingController textEditingController;
  final Function(String) onTextChanged;
  final Function(BuildContext)? onItemSelected;

  const CarInput({
    Key? key,
    required this.placeholder,
    required this.items,
    required this.textEditingController,
    required this.onTextChanged,
    this.onItemSelected,
  }) : super(key: key);

  @override
  State<CarInput> createState() => _CarInputState();
}

class _CarInputState extends State<CarInput> {
  late String selectedValue;
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.textEditingController.text.isEmpty
        ? widget.placeholder
        : widget.textEditingController.text;
  }

  void toggleDropdown() {
    setState(() {
      showDropdown = !showDropdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: showDropdown
            ? Border.all(color: wColor, width: 1)
            : Border.all(color: darkGrey, width: 1),
        color: grey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 54,
            child: GestureDetector(
              onTap: toggleDropdown, // Show the dropdown on tap
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true, // Make the TextField read-only
                  controller: widget.textEditingController,
                  style: const TextStyle(color: wColor),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: contentText(color: wColor),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 15,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: showDropdown ? lightGrey : bColor,
                        ),
                        height: 20,
                        width: 20,
                        child: Icon(
                          showDropdown
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: showDropdown ? bColor : black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 0.5,
            color: showDropdown ? lightGrey : null,
          ),
          if (showDropdown)
            ListView.separated(
              padding: EdgeInsets.only(top: 0, bottom: 5),
              shrinkWrap: true,
              itemCount: widget.items
                  .where((item) => item != widget.textEditingController.text)
                  .length,
              separatorBuilder: (context, index) => const Divider(
                color: lightGrey,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                final filteredItems = widget.items
                    .where((item) => item != widget.textEditingController.text)
                    .toList();
                final item = filteredItems[index];
                return SizedBox(
                  height: 56,
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item,
                        style: contentText(color: wColor),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedValue = item;
                        widget.textEditingController.text = item;
                        showDropdown = false;
                      });

                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(context);
                      }
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String value;

  const InfoField({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: darkGrey,
          width: 1.5,
        ),
        color: grey,
      ),
      height: 54,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            value,
            style: contentText(color: wColor),
          ),
        ),
      ),
    );
  }
}

class CarRegisterField extends StatefulWidget {
  final Function() onCarListLoading;

  const CarRegisterField({
    super.key,
    required this.onCarListLoading,
  });

  @override
  State<CarRegisterField> createState() => _CarRegisterFieldState();
}

class _CarRegisterFieldState extends State<CarRegisterField> {
  bool isCarEmpty = true;
  TextEditingController carController = TextEditingController();

  void onCarText(String value) {
    setState(() {
      isCarEmpty = value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: darkGrey, width: 1.5),
        color: grey,
      ),
      height: 54,
      child: TextField(
        controller: carController,
        style: contentText(color: wColor),
        decoration: InputDecoration(
          hintText: '차량 번호를 입력하세요.',
          hintStyle: contentText(),
          contentPadding: const EdgeInsets.only(
            top: 19.5,
            bottom: 19.5,
            left: 15,
          ),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(
              right: 10.0,
              top: 10,
              bottom: 10,
            ),
            child: InkWell(
              onTap: () async {
                if (!isCarEmpty) {
                  await ApiService.saveCar(carController.text);
                  widget.onCarListLoading(); // Invoke the callback function
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: bColor,
                ),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  '등록',
                  style: TextStyle(
                    fontFamily: 'luxFont',
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: black,
                  ),
                ),
              ),
            ),
          ),
        ),
        onChanged: (value) {
          onCarText(value);
        },
      ),
    );
  }
}

class UserCar extends StatelessWidget {
  final String carNumber;
  final void Function() onPressed;

  const UserCar({
    super.key,
    required this.carNumber,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: InkWell(
        onTap: () => onPressed(),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: grey,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: darkGrey,
                ),
                child: const Icon(
                  Icons.directions_car_outlined,
                  color: bColor,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 17,
                    bottom: 17,
                    right: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        carNumber,
                        style: contentText(
                          color: wColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
