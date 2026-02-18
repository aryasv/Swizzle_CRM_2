class CompanyDetailsDealsModel {
  final int id;
  final String uuid;
  final String title;
  final String amount;
  final String userName;
  final String date;

  CompanyDetailsDealsModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.amount,
    required this.userName,
    required this.date,
  });

  factory CompanyDetailsDealsModel.fromJson(Map<String, dynamic> json) {
    final creator = json['creator'] ?? {};
    return CompanyDetailsDealsModel(
      id: json['deal_id'] ?? 0,
      uuid: json['deal_uuid'] ?? '',
      title: json['deal_title'] ?? '',
      amount: json['deal_amount'] ?? '',
      userName: creator['name'] ?? '',
      date: creator['created_at'] ?? '',
    );
  }
}
