import 'package:flutter/material.dart';
import '../styles.dart';

class DropdownInput extends StatefulWidget {
  final String placeholder;
  final List<String> items;
  final String searchIconOn;
  final String searchIconOff;
  final TextEditingController textEditingController;
  final Function(String) onTextChanged;

  const DropdownInput({
    Key? key,
    required this.placeholder,
    required this.items,
    required this.searchIconOn,
    required this.searchIconOff,
    required this.textEditingController,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? selectedValue;
  bool showDropdown = false;

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
        border: widget.textEditingController.text.isEmpty
            ? Border.all(color: dialogColor, width: 1)
            : Border.all(color: wColor, width: 1),
        color: grey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 54,
            child: TextField(
              controller: widget.textEditingController,
              style: const TextStyle(color: wColor),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: contentText(color: lightGrey),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 19.5,
                  horizontal: 15,
                ),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.textEditingController.clear();
                      toggleDropdown();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      widget.textEditingController.text.isEmpty
                          ? widget.searchIconOn
                          : widget.searchIconOff,
                      width: 10,
                      height: 10,
                    ),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedValue = null; // Clear the selected value
                });
                widget.onTextChanged(value);
                if (value.isNotEmpty) {
                  setState(() {
                    showDropdown = true;
                  });
                } else {
                  setState(() {
                    showDropdown = false;
                  });
                }
              },
            ),
          ),
          if (showDropdown)
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const Divider(
                color: lightGrey,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return ListTile(
                  title: Text(
                    item,
                    style: contentText(color: lightGrey),
                  ),
                  onTap: () {
                    setState(() {
                      selectedValue = item;
                      widget.textEditingController.text = item;
                      showDropdown = false;
                    });
                  },
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
        border: widget.textEditingController.text.isEmpty
            ? Border.all(color: dialogColor, width: 1.5)
            : Border.all(color: wColor, width: 1.5),
        color: grey,
      ),
      height: 54,
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
