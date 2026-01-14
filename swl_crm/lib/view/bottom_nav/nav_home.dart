import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class NavHome extends StatelessWidget {
  const NavHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
