class ProductModel {
  final int id;
  final String uuid;
  final String name;
  final String code;
  final double price;
  final bool isDeleted;

  ProductModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.code,
    required this.price,
    required this.isDeleted,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      uuid: json['product_uuid'] ?? json['uuid'] ?? '',
      name: json['product_name'] ?? json['name'] ?? '',
      code: json['product_code'] ?? json['code'] ?? '',
      price: double.tryParse(
        json['product_price']?.toString() ??
            json['price']?.toString() ??
            '0',
      ) ??
          0.0,
      isDeleted: json['is_deleted'] == true,
    );
  }


  String get formattedPrice => '₹ ${price.toStringAsFixed(2)}';
}
