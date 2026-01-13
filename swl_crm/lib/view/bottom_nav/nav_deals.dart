import 'package:flutter/material.dart';

class NavDeals extends StatelessWidget {
  const NavDeals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Deals',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
