import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/tasks_model.dart';

class NavTasks extends StatefulWidget {
  const NavTasks({super.key});

  @override
  State<NavTasks> createState() => _NavTasksState();
}

class _NavTasksState extends State<NavTasks> {

  final WebFunctions _api = WebFunctions();
  bool isLoading = true;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);

    final response = await _api.tasks(
      context: context,
      status: "active",
      page: 1,
    );

    if (!mounted) return;

    if (response.result) {
      final List list = response.response!['data']['tasks'] ?? [];
      tasks = list.map((e) => TaskModel.fromJson(e)).toList();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CustomAppBar(
            title: 'Tasks',
          ),



          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TasksList(tasks: tasks),
          ),
          SizedBox(height: 48,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
