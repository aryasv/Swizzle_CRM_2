import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class NavTasks extends StatelessWidget {
  const NavTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Tasks',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
