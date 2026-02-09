class DealDetailsResponse {
  final DealDetailsModel? deal;
  final List<DealMenuModel> menus;

  DealDetailsResponse({
    this.deal,
    required this.menus,
  });

  factory DealDetailsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return DealDetailsResponse(
      deal: data['deal'] != null ? DealDetailsModel.fromJson(data['deal']) : null,
      menus: (data['menus'] as List? ?? [])
          .map((e) => DealMenuModel.fromJson(e))
          .toList(),
    );
  }
}

class DealDetailsModel {
  final int id;
  final String uuid;
  final String title;
  final String status;
  final String clientName;
  final String closingDate;
  final String amount;
  final String currency;
  final int clientId;
  final int companyId;
  final int accountStageId;
  final int accountId;

  DealDetailsModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.status,
    required this.clientName,
    required this.closingDate,
    required this.amount,
    required this.currency,
    required this.clientId,
    required this.companyId,
    required this.accountStageId,
    required this.accountId,
  });

  factory DealDetailsModel.fromJson(Map<String, dynamic> json) {
    return DealDetailsModel(
      id: json['id'] ?? 0,
      uuid: json['deal_uuid'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      clientName: json['client_name'] ?? '',
      closingDate: json['closing_date'] ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      currency: json['currency'] ?? '₹',
      clientId: json['client_id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      accountStageId: json['account_stage_id'] ?? 0,
      accountId: json['account_id'] ?? 0,
    );
  }
}

class DealMenuModel {
  final String label;
  final String menuType;
  final String icon;

  DealMenuModel({
    required this.label,
    required this.menuType,
    required this.icon,
  });

  factory DealMenuModel.fromJson(Map<String, dynamic> json) {
    return DealMenuModel(
      label: json['label'] ?? '',
      menuType: json['menu_type'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
