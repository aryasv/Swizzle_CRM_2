import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/tasks_model.dart';

class TasksList extends StatelessWidget {
  final List<TaskModel> tasks;
  final VoidCallback onRefresh;
  final bool isActive;

  const TasksList({
    super.key,
    required this.tasks,
    required this.onRefresh,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _TaskCard(
          task: tasks[index],
          onRefresh: onRefresh,
          isActive: isActive,
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onRefresh;
  final bool isActive;

  const _TaskCard({
    required this.task,
    required this.onRefresh,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title And menu
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                onSelected: (value) async {
                  if (value == 'edit') {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasksFormPage(
                          taskUuid: task.uuid,
                          taskId: task.id,
                        ),
                      ),
                    );
                    
                    if (result == true) {
                      onRefresh();
                    }
                  } else if (value == 'deactivate') {
                    _updateStatus(context, 'deactivate');
                  } else if (value == 'activate') {
                    _updateStatus(context, 'activate');
                  }
                },
                child: const Icon(Icons.more_vert, size: 22),
                itemBuilder: (context) {
                  if (isActive) {
                    return const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'deactivate',
                        child: Text('Deactivate'),
                      ),
                    ];
                  } else {
                    return const [
                      PopupMenuItem(
                        value: 'activate',
                        child: Text('Activate'),
                      ),
                    ];
                  }
                },
              ),
            ],
          ),



          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          if (task.relatedTo.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.link, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    task.relatedTo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

          ],

          const SizedBox(height: 8),
          // Due date And status
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                task.dueDate,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 10),
              _StatusChip(isCompleted: isCompleted),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Assigned To',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            task.assignedTo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String action) async {
    final WebFunctions api = WebFunctions();
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final res = await api.deleteTask(
      context: context,
      taskUuid: task.uuid,
      taskId: task.id,
      action: action,
    );
    
    // Hide loading
    Navigator.pop(context);

    if (res.result) {
      onRefresh();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task ${action}d successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _StatusChip extends StatelessWidget {
  final bool isCompleted;

  const _StatusChip({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFFE7F4EA)
            : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isCompleted ? 'COMPLETED' : 'PENDING',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isCompleted ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
