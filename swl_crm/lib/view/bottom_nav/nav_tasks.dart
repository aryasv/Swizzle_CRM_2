import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/tasks_model.dart';

class NavTasks extends StatefulWidget {
  const NavTasks({super.key});

  @override
  State<NavTasks> createState() => _NavTasksState();
}

class _NavTasksState extends State<NavTasks>
    with SingleTickerProviderStateMixin {
  final WebFunctions _api = WebFunctions();

  late TabController _tabController;

  bool isLoading = true;
  List<TaskModel> activeTasks = [];
  List<TaskModel> inactiveTasks = [];

  int activeCount = 0;
  int inactiveCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);

    final activeRes = await _api.tasks(
      context: context,
      status: 'active',
      page: 1,
    );

    final inactiveRes = await _api.tasks(
      context: context,
      status: 'inactive',
      page: 1,
    );

    if (!mounted) return;

    if (activeRes.result) {
      final data = activeRes.response!['data'];
      activeTasks = (data['tasks'] as List)
          .map((e) => TaskModel.fromJson(e))
          .toList();
      activeCount = data['active_count'] ?? 0;
    }

    if (inactiveRes.result) {
      final data = inactiveRes.response!['data'];
      inactiveTasks = (data['tasks'] as List)
          .map((e) => TaskModel.fromJson(e))
          .toList();
      inactiveCount = data['inactive_count'] ?? 0;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomAppBar(title: 'Tasks'),

          CustomTabBar(
            controller: _tabController,
            tabs: [
              CustomTabItem(label: 'Active', count: activeCount),
              CustomTabItem(label: 'Inactive', count: inactiveCount),
            ],
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                TasksList(tasks: activeTasks, onRefresh: _loadTasks),
                TasksList(tasks: inactiveTasks, onRefresh: _loadTasks),
              ],
            ),
          ),
          SizedBox(height: 48,)
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TasksFormPage(),
            ),
          );

          if (result == true) {
            _loadTasks();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
