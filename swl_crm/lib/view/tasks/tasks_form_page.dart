import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class TasksFormPage extends StatefulWidget {
  final String? taskUuid;
  final int? taskId;

  const TasksFormPage({super.key, this.taskUuid, this.taskId});

  @override
  State<TasksFormPage> createState() => _TasksFormPageState();
}

class _TasksFormPageState extends State<TasksFormPage> {
  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _assignee = TextEditingController();


  DateTime? _dueDate;
  bool _repeat = false;
  bool _reminder = false;
  bool _highPriority = false;

  String? _relatedTo;

  final List<String> _assignees = ['Sarah Johnson', 'Anish Joseph', 'Kiran Karma'];
  final List<String> _relatedOptions = ['None', 'Contacts', 'Companies'];

  final WebFunctions _api = WebFunctions();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskUuid != null) {
      _loadTaskDetails();
    }
  }

  Future<void> _loadTaskDetails() async {
    setState(() => isLoading = true);
    final res = await _api.editTask(
      context: context,
      taskUuid: widget.taskUuid!,
      taskId: widget.taskId ?? 0, 
    );

    if (res.result) {
      final data = res.response!['data'];
      final taskData = data['task'];
      
      if (taskData != null) {
        _taskName.text = taskData['name'] ?? '';
        _description.text = taskData['description'] ?? '';

        if (taskData['assigned_user_id'] == 1) _assignee.text = "Sarah Johnson";
        else if (taskData['assigned_user_id'] == 2) _assignee.text = "Anish Joseph";
        else if (taskData['assigned_user_id'] == 3) _assignee.text = "Kiran Karma";
        else _assignee.text = "Sarah Johnson"; // Fallback
        
        if (taskData['due_date'] != null) {
          try {
            List<String> parts = taskData['due_date'].toString().split('/');
            if (parts.length == 3) {
              _dueDate = DateTime(
                int.parse(parts[2]), // YYYY
                int.parse(parts[1]), // MM
                int.parse(parts[0]), // DD
              );
            } else {
               _dueDate = DateTime.tryParse(taskData['due_date']);
            }
          } catch (e) {
            print("Error parsing date: $e");
          }
        }
        
        _repeat = taskData['recurring'] == 1 || taskData['recurring'] == true;
        _reminder = taskData['has_reminder'] == 1 || taskData['has_reminder'] == true;
        _highPriority = taskData['is_high_priority'] == 1 || taskData['is_high_priority'] == true;
        
        // Map related module
        if (taskData['related_to_module_id'] == 1) _relatedTo = 'Contacts';
        else if (taskData['related_to_module_id'] == 2) _relatedTo = 'Companies';
      }
    } else {
      _showError(res.error ?? 'Failed to load task details');
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _taskName.dispose();
    _description.dispose();
    _assignee.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (_taskName.text.trim().isEmpty) {
      _showError('Task Name is required');
      return;
    }

    if (_assignee.text.trim().isEmpty) {
      _showError('Assignee is required');
      return;
    }

    setState(() => isLoading = true);

    // Map assignee name to ID (Mock logic)
    int assignedId = 1;
    if (_assignee.text.contains("Anish")) assignedId = 2;
    if (_assignee.text.contains("Kiran")) assignedId = 3;

    // Map related module
    int? moduleRelatedId;
    if (_relatedTo == 'Contacts') moduleRelatedId = 1;
    if (_relatedTo == 'Companies') moduleRelatedId = 2;

    ApiResponse res;
    if (widget.taskUuid != null) {
      // Update
      res = await _api.updateTask(
        context: context,
        taskUuid: widget.taskUuid!,
        name: _taskName.text.trim(),
        description: _description.text.trim(),
        assignedUserId: assignedId,
        dueDate: _dueDate?.toIso8601String().split('T').first,
        recurring: _repeat ? 1 : 0,
        hasReminder: _reminder ? 1 : 0,
        reminderOnId: _reminder ? 1 : null,
        reminderAt: _reminder ? "10:00" : null,
        isHighPriority: _highPriority ? 1 : 0,
        relatedToModuleId: moduleRelatedId,
        repeatsEvery: _repeat ? "Every Week" : null,
        repeatUntil: _repeat ? DateTime.now().add(const Duration(days: 30)).toIso8601String().split('T').first : null,
      );
    } else {
      // Create
      res = await _api.storeTask(
        context: context,
        name: _taskName.text.trim(),
        description: _description.text.trim(),
        assignedUserId: assignedId,
        dueDate: _dueDate?.toIso8601String().split('T').first,
        recurring: _repeat ? 1 : 0,
        hasReminder: _reminder ? 1 : 0,
        reminderOnId: _reminder ? 1 : null,
        reminderAt: _reminder ? "10:00" : null,
        isHighPriority: _highPriority ? 1 : 0,
        relatedToModuleId: moduleRelatedId,
        repeatsEvery: _repeat ? "Every Week" : null,
        repeatUntil: _repeat ? DateTime.now().add(const Duration(days: 30)).toIso8601String().split('T').first : null,
      );
    }

    setState(() => isLoading = false);

    if (res.result) {
      if (mounted) Navigator.pop(context, true);
    } else {
      _showError(res.error ?? 'Failed to save task');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CustomAppBar(
            title: widget.taskUuid != null ? 'Edit Task' : 'Create Task',
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  _sectionTitle('Task Information'),

                  _field(
                    hint: 'Task Name *',
                    controller: _taskName,
                  ),

                  _field(
                    hint: 'Assignee *',
                    controller: _assignee,
                  ),


                  _dateField(),

                  _checkbox('Repeat', _repeat, (v) {
                    setState(() => _repeat = v);
                  }),

                  _checkbox('Reminder', _reminder, (v) {
                    setState(() => _reminder = v);
                  }),

                  _dropdown(
                    hint: 'Related To',
                    value: _relatedTo,
                    items: _relatedOptions,
                    onChanged: (v) => setState(() => _relatedTo = v),
                  ),

                  const SizedBox(height: 24),


                  _sectionTitle('Additional Information'),

                  _field(
                    hint: 'Description',
                    controller: _description,
                    maxLines: 4,
                  ),

                  _checkbox('Mark as High Priority', _highPriority, (v) {
                    setState(() => _highPriority = v);
                  }),

                  const SizedBox(height: 32),


                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _saveTask,
                      icon: isLoading
                          ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                          : Icon(widget.taskUuid != null ? Icons.edit : Icons.add, color: Colors.white),
                      label: Text(
                        isLoading 
                            ? (widget.taskUuid != null ? 'Updating...' : 'Creating...') 
                            : (widget.taskUuid != null ? 'Update Task' : 'Create Task'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A7DE1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _field({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
        ),
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _pickDate,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                _dueDate == null
                    ? 'Select due date'
                    : _dueDate!.toIso8601String().split('T').first,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkbox(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-8, 0),
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

            ),
          ),
          Transform.translate(
            offset: const Offset(-6, 0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }


}
