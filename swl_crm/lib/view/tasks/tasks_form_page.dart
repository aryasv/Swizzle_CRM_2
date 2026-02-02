import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class TasksFormPage extends StatefulWidget {
  const TasksFormPage({super.key});

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

  Future<void> _createTask() async {
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

    final res = await _api.storeTask(
      context: context,
      name: _taskName.text.trim(),
      description: _description.text.trim(),
      assignedUserId: assignedId,
      dueDate: _dueDate?.toIso8601String().split('T').first,
      recurring: _repeat ? 1 : 0,
      hasReminder: _reminder ? 1 : 0,
      isHighPriority: _highPriority ? 1 : 0,
      relatedToModuleId: moduleRelatedId,
      // Default/Mock values for demo
      repeatsEvery: _repeat ? "Every Week" : null,
      repeatUntil: _repeat ? DateTime.now().add(const Duration(days: 30)).toIso8601String().split('T').first : null,
      reminderAt: _reminder ? "10:00" : null,
    );

    setState(() => isLoading = false);

    if (res.result) {
      if (mounted) Navigator.pop(context, true);
    } else {
      _showError(res.error ?? 'Failed to create task');
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
          const CustomAppBar(
            title: 'Create Task',
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
                      onPressed: isLoading ? null : _createTask,
                      icon: isLoading
                          ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.add, color: Colors.white),
                      label: Text(
                        isLoading ? 'Creating...' : 'Create Task',
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
