import 'package:flutter/material.dart';

class DropdownInput extends StatefulWidget {
  final List<String> items;
  final String openIcon;
  final String closeIcon;

  const DropdownInput({
    Key? key,
    required this.items,
    this.openIcon = 'assets/searchIconOn.png',
    this.closeIcon = 'assets/searchIconOff.png',
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DropdownInputState createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isOpen = false;
  String _selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      height: 54,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _isOpen ? Colors.white : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: const Color(0xFF3E3E3E),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                icon: Image.asset(_isOpen ? widget.closeIcon : widget.openIcon),
                items: widget.items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: _controller.text.contains(value)
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedItem = newValue!;
                    _controller.text = _selectedItem;
                    _isOpen = !_isOpen;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
