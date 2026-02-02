class TaskModel {
  final int id;
  final String uuid;
  final String title;
  final String dueDate;
  final String status;
  final String relatedTo;
  final String assignedTo;
  final bool isDeleted;

  TaskModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.dueDate,
    required this.status,
    required this.relatedTo,
    required this.assignedTo,
    required this.isDeleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      uuid: json['uuid'],
      title: json['name'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? 'pending',
      relatedTo: (json['related_to_display'] == null ||
          json['related_to_display'] == '-' ||
          json['related_to_display'].toString().isEmpty)
          ? ''
          : json['related_to_display'],
      assignedTo: (json['assigned_to'] == null ||
          json['assigned_to'] == '-' ||
          json['assigned_to'].toString().isEmpty)
          ? 'Unassigned'
          : json['assigned_to'],
      isDeleted: json['is_deleted'] == true,
    );
  }

  bool get isCompleted => status == 'completed';
}
