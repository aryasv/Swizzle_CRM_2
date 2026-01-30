class ProductModel {
  final int id;
  final String uuid;
  final String name;
  final String code;
  final double price;
  final String currency;

  ProductModel({
    required this.id,
    required this.uuid,
    required this.name,
    required this.code,
    required this.price,
    required this.currency,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      uuid: json['product_uuid'],
      name: json['name'],
      code: json['code'],
      price: double.parse(json['price'].toString()),
      currency: json['currency'] ?? '₹',
    );
  }

  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
}
