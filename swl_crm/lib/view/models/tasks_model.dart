class TaskModel {
  final int id;
  final String uuid;
  final String title;
  final String dueDate;
  final bool isHighPriority;
  final String assignedTo;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.dueDate,
    required this.isHighPriority,
    required this.assignedTo,
    required this.isCompleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      uuid: json['uuid'],
      title: json['name'] ?? '',
      dueDate: json['due_date'] ?? '',
      isHighPriority: json['is_high_priority'] == 1,
      assignedTo: json['assigned_to'] ?? '',
      isCompleted: json['is_completed'] == 1,
    );
  }

  String get priorityLabel => isHighPriority ? 'URGENT' : 'NORMAL';
}
