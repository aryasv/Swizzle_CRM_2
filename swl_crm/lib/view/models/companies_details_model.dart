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
  final List<MenuModel> menus;

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
    required this.menus,
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
      menus: (json['menus'] as List<dynamic>?)
              ?.map((e) => MenuModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MenuModel {
  final String label;
  final String menuType;
  final String icon;

  MenuModel({
    required this.label,
    required this.menuType,
    required this.icon,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      label: json['label'] ?? '',
      menuType: json['menu_type'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
