import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class NavDeals extends StatelessWidget {
  const NavDeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            CustomAppBar(

              title: 'Deals',
              showBack: false,
              rightAction1: const Icon(Icons.filter_list, size: 20),
              onRightAction1: () {

              },
              rightAction2: const Icon(Icons.view_module_outlined, size: 20),
              onRightAction2: () {

              },
            ),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search deals...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Deals list
            const Expanded(
              child: DealsList(),
            ),
          ],
        ),
      ),

      // Floating add button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
