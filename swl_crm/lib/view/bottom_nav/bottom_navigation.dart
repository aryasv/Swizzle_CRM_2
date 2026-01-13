import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  Widget _buildItem({
    required int index,
    required String label,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    final bool isActive = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isActive ? activeIcon : inactiveIcon,
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.blue : Colors.grey,
                fontWeight:
                isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildItem(
              index: 0,
              label: 'Home',
              activeIcon: 'assets/images/nav_home_active.png',
              inactiveIcon: 'assets/images/dummy_icon.png',
            ),
            _buildItem(
              index: 1,
              label: 'Deals',
              activeIcon: 'assets/images/nav_deals_active.png',
              inactiveIcon: 'assets/images/dummy_icon.png',
            ),
            _buildItem(
              index: 2,
              label: 'Tasks',
              activeIcon: 'assets/images/nav_tasks_active.png',
              inactiveIcon: 'assets/images/dummy_icon.png',
            ),
            _buildItem(
              index: 3,
              label: 'Settings',
              activeIcon: 'assets/images/nav_settings_active.png',
              inactiveIcon: 'assets/images/dummy_icon.png',
            ),
          ],
        ),
      ),
    );
  }
}
