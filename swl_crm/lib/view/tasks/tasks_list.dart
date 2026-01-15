import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  // Static List
  static final List<Map<String, String>> _tasks = [
    {
      'title': 'Follow up with Acme Corp',
      'desc': 'Discuss contract terms and pricing',
      'date': 'Nov 13, 14:00',
      'priority': 'HIGH',
      'assigned': 'Kiran Karma',
    },
    {
      'title': 'Prepare proposal for Global Solutions',
      'desc': 'Create detailed proposal document',
      'date': 'Nov 14, 16:00',
      'priority': 'HIGH',
      'assigned': 'Kiran Karma',
    },
    {
      'title': 'Schedule demo call',
      'desc': 'Demo with Enterprise Systems team',
      'date': 'Nov 12, 10:00',
      'priority': 'URGENT',
      'assigned': 'Kiran Karma',
    },
    {
      'title': 'Schedule demo call',
      'desc': 'Demo with Enterprise Systems team',
      'date': 'Nov 12, 10:00',
      'priority': 'URGENT',
      'assigned': 'Kiran Karma',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return TaskCard(
          title: task['title']!,
          description: task['desc']!,
          date: task['date']!,
          priority: task['priority']!,
          assignedTo: task['assigned']!,
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String priority;
  final String assignedTo;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.assignedTo,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUrgent = priority == 'URGENT';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title And menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                child: const Icon(Icons.more_vert, size: 24),
                onSelected: (value) {},
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit,
                            size: 18, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete,
                            size: 18, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          //  Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          //  Date And Priority
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              _PriorityChip(
                label: priority,
                isUrgent: isUrgent,
              ),
            ],
          ),

          const SizedBox(height: 12),

          //  Assigned to
          const Text(
            'Assigned To',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            assignedTo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final bool isUrgent;

  const _PriorityChip({
    super.key,
    required this.label,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent
            ? const Color(0xFFE0E0E0)
            : const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isUrgent ? Colors.black : Colors.red,
        ),
      ),
    );
  }
}
