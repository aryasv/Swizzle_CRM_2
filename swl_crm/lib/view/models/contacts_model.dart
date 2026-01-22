class ContactsResponse {
  final int activeCount;
  final int inactiveCount;
  final List<ContactModel> contacts;

  ContactsResponse({
    required this.activeCount,
    required this.inactiveCount,
    required this.contacts,
  });

  factory ContactsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return ContactsResponse(
      activeCount: data['active_count'] ?? 0,
      inactiveCount: data['inactive_count'] ?? 0,
      contacts: (data['clients'] as List? ?? [])
          .map((e) => ContactModel.fromJson(e))
          .toList(),
    );
  }
}

class ContactModel {
  final int id;
  final String uuid;
  final String name;
  final String email;
  final String phone;
  final int? companyId;
  final String companyName;
  final bool isDeleted;
  final DateTime? createdAt;

  ContactModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    required this.phone,
    this.companyId,
    required this.companyName,
    required this.isDeleted,
    this.createdAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? 0,
      uuid: json['client_uuid'] ?? '',
      name: json['client_name'] ?? '',
      email: json['client_email'] ?? '',
      phone: json['client_phone'] ?? '',
      companyId: json['company_id'],
      companyName: json['company_name'] ?? 'N/A',
      isDeleted: json['is_deleted'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }


  String get initials {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
