class TaskModel {
  final int id;
  final String uuid;
  final String title;

  final String dueDate;
  final bool isHighPriority;
  final bool isCompleted;
  final String status;

  final String relatedTo;
  final String assignedTo;

  final bool isDeleted;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.dueDate,
    required this.isHighPriority,
    required this.isCompleted,
    required this.status,
    required this.relatedTo,
    required this.assignedTo,
    required this.isDeleted,
    required this.createdAt,
  });


  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      title: json['name'] ?? '',

      dueDate: json['due_date'] ?? '',
      isHighPriority: json['is_high_priority'] == 1,
      isCompleted: json['is_completed'] == 1,
      status: json['status'] ?? '',

      relatedTo: json['related_to_display'] ?? '-',
      assignedTo: json['assigned_to'] ?? '',

      isDeleted: json['is_deleted'] == true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(),
    );
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCompletedStatus => status.toLowerCase() == 'completed';

  String get priorityLabel => isHighPriority ? 'High' : 'Normal';
}
