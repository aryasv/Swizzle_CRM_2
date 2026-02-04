class CompanyDetailsModel {
  final int id;
  final String uuid;
  final String name;
  final String email;
  final String phone;
  final String website;
  final String address;
  final String city;
  final String zip;

  CompanyDetailsModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.city,
    required this.zip,
  });

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    final company = json['company'];

    return CompanyDetailsModel(
      id: company['id'],
      uuid: company['uuid'],
      name: company['name'] ?? '',
      email: company['email'] ?? '',
      phone: company['phone'] ?? '',
      website: company['website'] ?? '',
      address: company['address'] ?? '',
      city: company['city'] ?? '',
      zip: company['zip'] ?? '',
    );
  }
}
