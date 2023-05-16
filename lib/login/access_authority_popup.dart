import 'package:flutter/material.dart';

class AuthorityPopup extends StatefulWidget {
  const AuthorityPopup({super.key});

  @override
  State<AuthorityPopup> createState() => _AuthorityPopupState();
}

class _AuthorityPopupState extends State<AuthorityPopup> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Popup Demo'),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () => _showPopup(context),
            child: const Text('Show Popup'),
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Popup Title'),
          content: const Text('This is the content of the popup.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
