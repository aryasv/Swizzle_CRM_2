import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class CustomTabItem {
  final String label;
  final int? count; 

  const CustomTabItem({
    required this.label,
    this.count,
  });
}

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<CustomTabItem> tabs;

  final Color activeColor;
  final Color inactiveColor;
  final Color indicatorColor;

  final double fontSize;
  final FontWeight activeWeight;
  final FontWeight inactiveWeight;

  final EdgeInsetsGeometry padding;
  final double indicatorHeight;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.activeColor = const Color(0xFF2A7DE1),
    this.inactiveColor = Colors.black54,
    this.indicatorColor = const Color(0xFF2A7DE1),
    this.fontSize = 16,
    this.activeWeight = FontWeight.w600,
    this.inactiveWeight = FontWeight.w400,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.indicatorHeight = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: padding,
        child: TabBar(
          controller: controller,
          indicatorColor: indicatorColor,
          indicatorWeight: indicatorHeight,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.symmetric(vertical: 8),
          tabs: List.generate(
            tabs.length,
                (index) {
              final bool isActive = controller.index == index;
              final tab = tabs[index];

              return Tab(
                child: _TabLabel(
                  label: tab.label,
                  count: tab.count,
                  isActive: isActive,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  fontSize: fontSize,
                  activeWeight: activeWeight,
                  inactiveWeight: inactiveWeight,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final int? count;
  final bool isActive;

  final Color activeColor;
  final Color inactiveColor;
  final double fontSize;
  final FontWeight activeWeight;
  final FontWeight inactiveWeight;

  const _TabLabel({
    required this.label,
    required this.count,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.fontSize,
    required this.activeWeight,
    required this.inactiveWeight,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isActive ? activeColor : inactiveColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isActive ? activeWeight : inactiveWeight,
            color: textColor,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withOpacity(0.12)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: fontSize - 4,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
