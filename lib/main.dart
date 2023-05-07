import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _showFirstPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('First Popup'),
          content: const Text('Are you sure?'),
          actions: [
            RoundButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            RoundButton(
              label: 'Confirm',
              onPressed: () {
                Navigator.of(context).pop();
                _showSecondPopup(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSecondPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('액세스 권한'),
          content: const Text('Choose an option:'),
          actions: [
            RoundButton(
              label: '앱 사용 중에만 허용',
              onPressed: () {
                Navigator.of(context).pop();
                _showThirdPopup(context);
              },
            ),
            RoundButton(
              label: '항상 허용',
              onPressed: () {
                Navigator.of(context).pop();
                _showThirdPopup(context);
              },
            ),
            RoundButton(
              label: '허용 안 함',
              onPressed: () {
                Navigator.of(context).pop();
                _showThirdPopup(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showThirdPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('액세스 권한'),
          content: const Text('Choose an option:'),
          actions: [
            RoundButton(
              label: '앱 사용 중에만 허용',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            RoundButton(
              label: '항상 허용',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            RoundButton(
              label: '허용 안 함',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showFirstPopup(context),
      child: const Text('Show popup'),
    );
  }
}

class RoundButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const RoundButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }
}
