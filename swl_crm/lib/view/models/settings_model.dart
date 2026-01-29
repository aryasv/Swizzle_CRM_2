class SettingsItemModel {
  final String label;
  final String type;
  final String icon;

  SettingsItemModel({
    required this.label,
    required this.type,
    required this.icon,
  });

  factory SettingsItemModel.fromJson(Map<String, dynamic> json) {
    return SettingsItemModel(
      label: json['label'] ?? '',
      type: json['type'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class SettingsUserModel {
  final String name;
  final String email;
  final String role;

  SettingsUserModel({
    required this.name,
    required this.email,
    required this.role,
  });

  factory SettingsUserModel.fromJson(Map<String, dynamic> json) {
    return SettingsUserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
