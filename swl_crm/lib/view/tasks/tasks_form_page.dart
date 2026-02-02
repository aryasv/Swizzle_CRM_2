import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class TasksFormPage extends StatefulWidget {
  const TasksFormPage({super.key});

  @override
  State<TasksFormPage> createState() => _TasksFormPageState();
}

class _TasksFormPageState extends State<TasksFormPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  String priority = 'Medium';
  String status = 'Pending';
  String assignedTo = 'Sarah Johnson';
  String relatedTo = 'None';

  bool showTitleError = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    setState(() {
      showTitleError = _titleController.text.trim().isEmpty;
    });

    if (showTitleError) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Add Task',
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _sectionTitle('Basic Information'),

                  _label('Task Title'),
                  _textField(
                    controller: _titleController,
                    hint: 'Enter task title',
                    error: showTitleError,
                    maxLines: 3,
                  ),
                  if (showTitleError)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Task title is required',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 16),

                  _label('Description'),
                  _textField(
                    controller: _descriptionController,
                    hint: 'Enter task description',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  _sectionTitle('Due Date & Time'),

                  Row(
                    children: [
                      Expanded(child: _datePicker()),
                      const SizedBox(width: 12),
                      Expanded(child: _timePicker()),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _sectionTitle('Task Details'),

                  _label('Priority'),
                  _dropdown(
                    value: priority,
                    items: const ['Low', 'Medium', 'High'],
                    onChanged: (v) => setState(() => priority = v!),
                  ),

                  const SizedBox(height: 16),

                  _label('Status'),
                  _dropdown(
                    value: status,
                    items: const ['Pending', 'In Progress', 'Completed'],
                    onChanged: (v) => setState(() => status = v!),
                  ),

                  const SizedBox(height: 16),

                  _label('Assign To'),
                  _dropdown(
                    value: assignedTo,
                    items: const ['Sarah Johnson', 'John Doe'],
                    onChanged: (v) => setState(() => assignedTo = v!),
                  ),

                  const SizedBox(height: 24),

                  _sectionTitle('Related To (Optional)'),

                  _label('Entity Type'),
                  _dropdown(
                    value: relatedTo,
                    items: const ['None', 'Company', 'Contact', 'Product'],
                    onChanged: (v) => setState(() => relatedTo = v!),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveTask,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Create Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool error = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error ? Colors.red : Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error ? Colors.red : const Color(0xFF2A7DE1),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
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
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _datePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _dueDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() => _dueDate = picked);
        }
      },
      child: _pickerBox(
        icon: Icons.calendar_today,
        text: _dueDate == null
            ? 'Due Date'
            : _dueDate!.toIso8601String().split('T').first,
      ),
    );
  }

  Widget _timePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: _dueTime ?? TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() => _dueTime = picked);
        }
      },
      child: _pickerBox(
        icon: Icons.access_time,
        text: _dueTime == null
            ? 'Time'
            : _dueTime!.format(context),
      ),
    );
  }

  Widget _pickerBox({required IconData icon, required String text}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            text,
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
