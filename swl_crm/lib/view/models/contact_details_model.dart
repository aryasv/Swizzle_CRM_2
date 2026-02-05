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
    final data = json['client'] ?? json;
    return ContactDetailsModel(
      id: data['id'] is int ? data['id'] : int.tryParse(data['id'].toString()) ?? 0,
      uuid: data['uuid'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      fullName: data['full_name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      companyId: data['company_id'] is int ? data['company_id'] : int.tryParse(data['company_id'].toString()) ?? 0,
      companyName: data['company_name'] ?? '',
    );
  }
}
