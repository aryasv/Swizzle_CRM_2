import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  final Widget? rightAction1;
  final VoidCallback? onRightAction1;

  final Widget? rightAction2;
  final VoidCallback? onRightAction2;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.rightAction1,
    this.onRightAction1,
    this.rightAction2,
    this.onRightAction2,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.transparent,
        child: Row(
          children: [
            // Back button
            if (showBack)
              InkWell(
                onTap: onBack ?? () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, size: 18),
              ),

            if (showBack) const SizedBox(width: 12),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Right action 1
            if (rightAction1 != null)
              InkWell(
                onTap: onRightAction1,
                child: rightAction1!,
              ),

            if (rightAction1 != null && rightAction2 != null)
              const SizedBox(width: 16),

            // Right action 2
            if (rightAction2 != null)
              InkWell(
                onTap: onRightAction2,
                child: rightAction2!,
              ),
          ],
        ),
      ),
    );
  }
}
