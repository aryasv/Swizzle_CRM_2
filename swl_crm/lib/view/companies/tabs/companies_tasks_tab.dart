import 'package:flutter/material.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';

class CompaniesTasksTab extends StatefulWidget {
  final CompanyDetailsModel? company;
  const CompaniesTasksTab({super.key, this.company});

  @override
  State<CompaniesTasksTab> createState() => _CompaniesTasksTabState();
}

class _CompaniesTasksTabState extends State<CompaniesTasksTab> {

  final List<Map<String, dynamic>> _dummyTasks = [
    {
      'title': 'Test',
      'assigned_to': 'Test Assigned',
      'due_date': '02/17/2026',
      'status': 'pending',
    },
    {
      'title': 'Test',
      'assigned_to': 'Test Assigned',
      'due_date': '02/17/2026',
      'status': 'pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_dummyTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No tasks available',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _dummyTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final task = _dummyTasks[index];
        return _TaskItem(task: task);
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Map<String, dynamic> task;

  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              color: Color(0xFF2A7DE1),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Task Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      task['assigned_to'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${task['due_date']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
