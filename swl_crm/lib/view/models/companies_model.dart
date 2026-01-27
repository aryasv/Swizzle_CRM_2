class CompanyModel {
  final int id;
  final String uuid;

  final String name;
  final String phone;
  final String website;
  final String email;

  final String address;
  final String city;
  final String state;
  final String country;
  final String zip;

  final bool isDeleted;

  CompanyModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.phone,
    required this.website,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zip,
    required this.isDeleted,
  });


  factory CompanyModel.fromListJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      uuid: json['company_uuid'] ?? json['uuid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zip: json['zip'] ?? '',
      isDeleted: json['is_deleted'] == true,
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
