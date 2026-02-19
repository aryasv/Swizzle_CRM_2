class CompanyDetailsTasksModel {
  final int id;
  final String uuid;
  final String title;
  final String assignedTo;
  final String dueDate;
  final String status;

  CompanyDetailsTasksModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.assignedTo,
    required this.dueDate,
    required this.status,
  });

  factory CompanyDetailsTasksModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsTasksModel(
      id: json['task_id'] ?? 0,
      uuid: json['task_uuid'] ?? '',
      title: json['task_name'] ?? '',
      assignedTo: json['assignee_name'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
