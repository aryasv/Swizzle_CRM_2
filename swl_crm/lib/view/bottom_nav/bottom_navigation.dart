import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildItem({
    required int index,
    required String label,
    required String icon,
  }) {
    final bool isActive = currentIndex == index;
    final Color activeColor = Colors.blue;
    final Color inactiveColor = Colors.grey;

    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 6,
          bottom: 6
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? activeColor : inactiveColor,
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
              icon: 'assets/images/nav_home_active.png',
            ),
            _buildItem(
              index: 1,
              label: 'deals',
              icon: 'assets/images/nav_deals_active.png',
            ),
            _buildItem(
              index: 2,
              label: 'Tasks',
              icon: 'assets/images/nav_tasks_active.png',
            ),
            _buildItem(
              index: 3,
              label: 'Settings',
              icon: 'assets/images/nav_settings_active.png',
            ),
          ],
        ),
      ),
    );
  }
}
