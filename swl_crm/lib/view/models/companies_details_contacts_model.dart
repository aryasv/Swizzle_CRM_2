class CompanyDetailsContactsModel {
  final int id;
  final String uuid;
  final String name;
  final String phone;
  final String email;

  CompanyDetailsContactsModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory CompanyDetailsContactsModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsContactsModel(
      id: json['contact_id'] ?? json['client_id'] ?? 0,
      uuid: json['contact_uuid'] ?? json['client_uuid'] ?? '',
      name: json['name'] ?? json['client_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
