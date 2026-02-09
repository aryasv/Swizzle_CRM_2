class DealsResponse {
  final List<DealModel> deals;
  final int lastPage;
  final int total;

  DealsResponse({
    required this.deals,
    required this.lastPage,
    required this.total,
  });

  factory DealsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    final List list = data['deals'] ?? data['deal'] ?? [];
    
    return DealsResponse(
      deals: list.map((e) => DealModel.fromJson(e)).toList(),
      lastPage: data['last_page'] ?? 1,
      total: data['total'] ?? 0,
    );
  }
}

class DealModel {
  final int id;
  final String uuid;
  final String title;
  final String status;
  final String amount;
  final String closingDate;
  final String clientName;
  final String stageName;

  DealModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.status,
    required this.amount,
    required this.closingDate,
    required this.clientName,
    required this.stageName,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['id'] ?? 0,
      uuid: json['deal_uuid'] ?? json['uuid'] ?? '',
      title: json['title'] ?? 'No Title',
      status: json['status'] ?? 'Open',
      amount: json['amount']?.toString() ?? '0.00',
      closingDate: json['closing_date'] ?? 'N/A',
      clientName: json['client']?['client_name'] ?? json['client_name'] ?? 'N/A',
      stageName: json['account_stage']?['name'] ?? json['stage_name'] ?? '',
    );
  }
}
