import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class NavTasks extends StatefulWidget {
  const NavTasks({super.key});

  @override
  State<NavTasks> createState() => _NavTasksState();
}

class _NavTasksState extends State<NavTasks> with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All Tasks';
  bool _showSearch = false;

  final List<String> _filters = [
    'All Tasks',
    'High Priority',
    'Medium Priority',
    'Low Priority',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Custom App Bar
          CustomAppBar(
            title: 'Tasks',
            rightAction1: Icon(
              _showSearch ? Icons.close : Icons.search,
              size: 20,
            ),
            onRightAction1: () {
              setState(() {
                _showSearch = !_showSearch;
              });
            },
            rightAction2: const Icon(Icons.refresh, size: 20),
            onRightAction2: () {
              setState(() {
                _showSearch = false;
              });
            },
          ),


          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _showSearch
                ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  // later: filter API list
                },
              ),
            )
                : const SizedBox.shrink(),
          ),


          // Filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              items: _filters
                  .map(
                    (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF2A7DE1),
                  ),
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
            ),

          ),

          const SizedBox(height: 12),

          // Overdue
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Overdue',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '20',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),


          // Tasks list
          const Expanded(
            child: TasksList(),
          ),
        ],
      ),

      // Floating button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
