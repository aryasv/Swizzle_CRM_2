class DashboardModel {
  final User user;
  final Account account;
  final List<Statistic> statistics;
  final TeamOverview teamOverview;
  final String currentDate;
  final int accountId;

  DashboardModel({
    required this.user,
    required this.account,
    required this.statistics,
    required this.teamOverview,
    required this.currentDate,
    required this.accountId,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      user: User.fromJson(json['user']),
      account: Account.fromJson(json['account']),
      statistics: (json['statistics'] as List)
          .map((e) => Statistic.fromJson(e))
          .toList(),
      teamOverview: TeamOverview.fromJson(json['team_overview']),
      currentDate: json['current_date'] ?? '',
      accountId: json['account_id'] ?? 0,
    );
  }
}

// User
class User {
  final int id;
  final String name;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

// Account
class Account {
  final String name;
  final String currencySymbol;
  final String currencyCode;
  final String currencyName;
  final int totalUsers;

  Account({
    required this.name,
    required this.currencySymbol,
    required this.currencyCode,
    required this.currencyName,
    required this.totalUsers,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'] ?? '',
      currencySymbol: json['currency_symbol'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      currencyName: json['currency_name'] ?? '',
      totalUsers: json['total_users'] ?? 0,
    );
  }
}

//  Statistic
class Statistic {
  final int total;
  final String label;
  final String icon;

  Statistic({
    required this.total,
    required this.label,
    required this.icon,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      total: json['total'] ?? 0,
      label: json['label'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

// Team Overview
class TeamOverview {
  final int adminUsers;
  final int staffMembers;
  final int totalUsers;

  TeamOverview({
    required this.adminUsers,
    required this.staffMembers,
    required this.totalUsers,
  });

  factory TeamOverview.fromJson(Map<String, dynamic> json) {
    return TeamOverview(
      adminUsers: json['admin_users'] ?? 0,
      staffMembers: json['staff_members'] ?? 0,
      totalUsers: json['total_users'] ?? 0,
    );
  }
}
