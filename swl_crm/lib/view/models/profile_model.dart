class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String organization;
  final String memberSince;
  final String lastUpdated;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.organization,
    required this.memberSince,
    required this.lastUpdated,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle nested structure from API
    final userInfo = json['user_info'] ?? {};
    final accountInfo = json['account_info'] ?? {};

    // Fallback if data is flat (backward compatibility or different response structure)
    final id = userInfo['id'] ?? json['id'] ?? 0;
    final name = userInfo['name'] ?? json['name'] ?? 'N/A';
    final email = userInfo['email'] ?? json['email'] ?? 'N/A';
    // Phone is not in the provided response, checking potential keys
    final phone = userInfo['phone'] ?? json['phone'] ?? 'N/A';
    
    final role = accountInfo['role'] ?? json['role'] ?? 'User';
    final organization = accountInfo['organization'] ?? json['organization'] ?? 'Swizzle Innovations';
    final memberSince = accountInfo['member_since'] ?? json['created_at'] ?? 'N/A';
    final lastUpdated = accountInfo['last_updated_at'] ?? json['updated_at'] ?? 'N/A';

    return ProfileModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      organization: organization,
      memberSince: memberSince,
      lastUpdated: lastUpdated,
    );
  }

  String get initials {
    if (name.isEmpty || name == 'N/A') return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      if (parts.first.isEmpty) return '';
      return parts.first.substring(0, 1).toUpperCase();
    }
    if (parts[0].isEmpty || parts[1].isEmpty) return '';
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
