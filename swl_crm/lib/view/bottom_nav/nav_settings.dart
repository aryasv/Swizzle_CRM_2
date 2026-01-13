import 'package:flutter/material.dart';

class NavSettings extends StatelessWidget {
  const NavSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Settings',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
