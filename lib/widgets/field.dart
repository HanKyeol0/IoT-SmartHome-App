import 'package:flutter/material.dart';

import '../styles.dart';

class DropdownInput extends StatelessWidget {
  final String placeholder;
  final List<String>? items;

  const DropdownInput({
    super.key,
    required this.placeholder,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: dialogColor),
        color: grey,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            placeholder,
            style: const TextStyle(
                fontFamily: 'luxFont',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: lightGrey),
          ),
          value: null, // You can set the default value here
          onChanged: (String? value) {},
          items: items != null
              ? items!.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList()
              : null,
        ),
      ),
    );
  }
}
