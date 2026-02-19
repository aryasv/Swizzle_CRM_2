import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';
import 'package:swl_crm/view/models/companies_details_tasks_model.dart';
import 'package:intl/intl.dart';

class CompaniesTasksTab extends StatefulWidget {
  final CompanyDetailsModel? company;
  const CompaniesTasksTab({super.key, this.company});

  @override
  State<CompaniesTasksTab> createState() => _CompaniesTasksTabState();
}

class _CompaniesTasksTabState extends State<CompaniesTasksTab> {
  final List<CompanyDetailsTasksModel> _tasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (widget.company == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final api = WebFunctions();
    final response = await api.getCompanyTasks(
      context: context,
      companyUuid: widget.company!.uuid,
      companyId: widget.company!.id,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (response.result && response.response != null) {
        final data = response.response!['data'];
        
        List<dynamic>? tasksData;
        if (data != null) {

          if (data['task'] != null && data['task'] is List) {
            tasksData = data['task'];
          } 

          else if (data['tasks'] != null && data['tasks'] is List) {
            tasksData = data['tasks'];
          } 

          else if (data['data'] != null && data['data'] is List) { 
             tasksData = data['data'];
          } 
          
          else if (data is List) {
             tasksData = data;
          }
        }

        if (tasksData != null) {
          _tasks.clear();
          _tasks.addAll(
            tasksData.map((e) => CompanyDetailsTasksModel.fromJson(e)).toList(),
          );
        }
      } else {
        _error = response.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_tasks.isEmpty) {
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
            Icon(Icons.assignment_turned_in_outlined, size: 48, color: Colors.grey[300]),
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
      itemCount: _tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return _TaskItem(task: task);
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  final CompanyDetailsTasksModel task;

  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    String formattedDate = task.dueDate;
    try {
        if (task.dueDate.isNotEmpty) {
           final date = DateTime.parse(task.dueDate);
           formattedDate = DateFormat('MM/dd/yyyy').format(date);
        }
    } catch (_) {}

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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
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
                      task.assignedTo.isNotEmpty ? task.assignedTo : 'Unassigned',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (formattedDate.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Due: $formattedDate',
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
