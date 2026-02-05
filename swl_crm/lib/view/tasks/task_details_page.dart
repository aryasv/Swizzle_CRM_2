import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {

  @override
  void initState() {
    super.initState();
    _testApi();
  }

  Future<void> _testApi() async {
    final api = WebFunctions();

    final response = await api.taskDetails(
      context: context,
      taskUuid: "TASK_UUID",
      taskId: 69,
    );

    if (!mounted) return;

    if (response.result) {
      debugPrint("Task Details API RESPONSE:");
      debugPrint(response.response.toString());
    } else {
      debugPrint("Task Details API ERROR:");
      debugPrint(response.error);
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
                onSelected: (value) {
                  if (value == 'edit') {

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 72),
              child: Column(
                children: [
                  _taskHeader(),
                  const SizedBox(height: 16),

                  _section(
                    title: 'Basic Information',
                    icon: Icons.info_outline,
                    children: [
                      _infoRow(Icons.task_alt, 'Task Name', '6th task update'),
                      _infoRow(Icons.event, 'Due Date', '2026-02-03 00:00:00'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _section(
                    title: 'Description',
                    icon: Icons.description_outlined,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          '6th additional information',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
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
                      _infoRow(Icons.access_time, 'Created At', 'Feb 03, 2026'),
                      _infoRow(Icons.update, 'Updated At', 'Feb 03, 2026'),
                      _infoRow(Icons.link, 'Related To', '1'),
                      _infoRow(Icons.priority_high, 'Mark as High Priority', '1'),
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


  Widget _taskHeader() {
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
              const Expanded(
                child: Text(
                  '6th task update',
                  style: TextStyle(
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
              _statusChip('Overdue', Colors.red.shade100, Colors.red),
              const SizedBox(width: 8),
              _statusChip('HIGH PRIORITY', Colors.red.shade100, Colors.red),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          _metaRow(
            icon: Icons.person_outline,
            label: 'Assigned To',
            value: 'Jeena Elizabeth',
          ),

          const SizedBox(height: 8),

          _metaRow(
            icon: Icons.calendar_today,
            label: 'Due Date',
            value: 'Feb 03, 2026',
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


  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2A7DE1)),
          const SizedBox(width: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
          style: const TextStyle(fontSize: 13, color: Colors.grey),
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


  Widget _statusChip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
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
