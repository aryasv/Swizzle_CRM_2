class ContactDetailsModel {
  final int id;
  final String uuid;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String phone;
  final int companyId;
  final String companyName;

  ContactDetailsModel({
    required this.id,
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.companyId,
    required this.companyName,
  });

  factory ContactDetailsModel.fromJson(Map<String, dynamic> json) {
    return ContactDetailsModel(
      id: json['id'],
      uuid: json['uuid'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
    );
  }
}
