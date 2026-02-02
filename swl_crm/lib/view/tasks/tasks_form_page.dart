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

  DateTime? _dueDate;
  bool _repeat = false;
  bool _reminder = false;
  bool _highPriority = false;

  String? _assignee;
  String? _relatedTo;

  final List<String> _assignees = ['Sarah Johnson', 'Anish Joseph', 'Kiran Karma'];
  final List<String> _relatedOptions = ['None', 'Contacts', 'Companies'];

  @override
  void dispose() {
    _taskName.dispose();
    _description.dispose();
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

  void _createTask() {
    if (_taskName.text.trim().isEmpty) {
      _showError('Task Name is required');
      return;
    }

    if (_assignee == null) {
      _showError('Assignee is required');
      return;
    }



    Navigator.pop(context, true);
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

                  _dropdown(
                    hint: 'Assignee *',
                    value: _assignee,
                    items: _assignees,
                    onChanged: (v) => setState(() => _assignee = v),
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
                      onPressed: _createTask,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Create Task',
                        style: TextStyle(
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
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
