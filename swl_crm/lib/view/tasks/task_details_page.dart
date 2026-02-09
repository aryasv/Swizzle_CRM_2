import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/task_details_model.dart';
import 'package:swl_crm/view/tasks/tasks_form_page.dart';

class TaskDetailsPage extends StatefulWidget {
  final int taskId;
  final String taskUuid;

  const TaskDetailsPage({
    super.key,
    required this.taskId,
    required this.taskUuid,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskDetailsModel? task;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final api = WebFunctions();

    final response = await api.taskDetails(
      context: context,
      taskUuid: widget.taskUuid,
      taskId: widget.taskId,
    );

    if (!mounted) return;

    if (response.result) {
      try {
        final data = response.response!['data'];
        if (data.containsKey('task')) {
             task = TaskDetailsModel.fromJson(data['task']);
        } else {
             task = TaskDetailsModel.fromJson(data);
        }
      } catch (e) {
        debugPrint("Error parsing task details: $e");
      }
    } else {
      debugPrint("Task Details API ERROR: ${response.error}");
    }

    setState(() => isLoading = false);
  }
  
  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          /// Custom AppBar
          CustomAppBar(
            title: 'Task Details',
            showBack: true,
            rightAction1: SizedBox(
              height: 40,
              width: 40,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert, size: 22),
                offset: const Offset(0, 40),
                onSelected: (value) async {
                  if (value == 'edit' && task != null) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TasksFormPage(
                          taskId: widget.taskId,
                          taskUuid: widget.taskUuid,
                        ),
                      ),
                    );

                    if (result == true) {
                      _loadTask();
                    }
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : task == null
                    ? const Center(child: Text('Failed to load task'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 72),
                        child: Column(
                          children: [
                            _taskHeader(task!),
                            const SizedBox(height: 16),

                            _section(
                              title: 'Basic Information',
                              icon: Icons.info_outline,
                              children: [
                                _infoRow(Icons.task_alt, 'Task Name', task!.name),
                                _infoRow(
                                  Icons.event, 
                                  'Due Date', 
                                  _formatDate(task!.dueDate),
                                  valueColor: Colors.red,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _section(
                              title: 'Description',
                              icon: Icons.description_outlined,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      task!.description.isNotEmpty ? task!.description : 'No description',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            _section(
                              title: 'Other Information',
                              icon: Icons.info_outline,
                              children: [
                                _infoRow(Icons.access_time, 'Created At', _formatDate(task!.createdAt)),
                                _infoRow(Icons.update, 'Updated At', _formatDate(task!.updatedAt)),
                                if (task!.relatedDisplay.isNotEmpty)
                                  _infoRow(Icons.link, 'Related To', task!.relatedDisplay),
                                _infoRow(Icons.priority_high, 'Priority', task!.isHighPriority ? 'High' : 'Normal'),
                                _infoRow(Icons.repeat, 'Recurring', task!.recurring ? 'Yes' : 'No'),
                              ],
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }


  Widget _taskHeader(TaskDetailsModel t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF2A7DE1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _StatusChip(isCompleted: t.isCompleted),
              if (t.isHighPriority) ...[
                const SizedBox(width: 8),
                _priorityChip(),
              ]
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          _metaRow(
            icon: Icons.person_outline,
            label: 'Assigned To',
            value: t.assignedTo,
          ),

          const SizedBox(height: 8),

          _metaRow(
            icon: Icons.calendar_today,
            label: 'Due Date',
            value: _formatDate(t.dueDate),
            valueColor: Colors.red,
          ),
        ],
      ),
    );
  }


  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF2A7DE1)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }


  Widget _infoRow(
    IconData icon, 
    String label, 
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2A7DE1)),
          const SizedBox(width: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _metaRow({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _priorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'HIGH PRIORITY',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6),
      ],
    );
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
