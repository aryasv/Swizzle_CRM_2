import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'nav_home.dart';
import 'nav_deals.dart';
import 'nav_tasks.dart';
import 'nav_settings.dart';

class NavWrapper extends StatefulWidget {
  const NavWrapper({Key? key}) : super(key: key);

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    NavHome(),
    NavDeals(),
    NavTasks(),
    NavSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
