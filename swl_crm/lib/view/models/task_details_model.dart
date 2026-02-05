class TaskDetailsModel {
  final int id;
  final String uuid;
  final String name;
  final String description;
  final String dueDate;
  final bool isHighPriority;
  final bool isCompleted;
  final bool recurring;
  final String repeatsEvery;
  final String repeatUntil;
  final bool hasReminder;
  final String reminderAt;
  final String assignedTo;
  final String relatedModule;
  final String relatedDisplay;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  TaskDetailsModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.isHighPriority,
    required this.isCompleted,
    required this.recurring,
    required this.repeatsEvery,
    required this.repeatUntil,
    required this.hasReminder,
    required this.reminderAt,
    required this.assignedTo,
    required this.relatedModule,
    required this.relatedDisplay,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) {
    final related = json['related_to'] ?? {};

    return TaskDetailsModel(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['due_date'] ?? '',
      isHighPriority: json['is_high_priority'] == true,
      isCompleted: json['is_completed'] == true,
      recurring: json['recurring'] == true,
      repeatsEvery: json['repeats_every'] ?? '',
      repeatUntil: json['repeat_until'] ?? '',
      hasReminder: json['has_reminder'] == true,
      reminderAt: json['reminder_at'] ?? '',
      assignedTo: json['assigned_to'] ?? '',
      relatedModule: related['module_name'] ?? '',
      relatedDisplay: related['display_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      updatedBy: json['updated_by'] ?? '',
    );
  }
}
