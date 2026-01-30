import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/products_model.dart';
import 'products_create_page.dart';

class ProductsList extends StatelessWidget {
  final List<ProductModel> products;
  final bool isActive;
  final VoidCallback onRefresh;

  const ProductsList({
    super.key,
    required this.products,
    required this.isActive,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(
          product: products[index],
          isActive: isActive,
          onRefresh: onRefresh,
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isActive;
  final VoidCallback onRefresh;

  const _ProductCard({
    required this.product,
    required this.isActive,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final api = WebFunctions();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF2A7DE1),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.code,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.formattedPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A7DE1),
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            child: const Icon(Icons.more_vert, size: 20),
            onSelected: (value) async {
              if (value == 'edit') {
                 final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductsCreatePage(product: product),
                  ),
                );
                if (result == true) {
                  onRefresh();
                }
              }

              if (value == 'deactivate') {
                await api.deleteProduct(
                  context: context,
                  productUuid: product.uuid,
                  productId: product.id.toString(),
                  accountId: "1",
                  action: "deactivate",
                );
                onRefresh();
              }

              if (value == 'activate') {
                await api.deleteProduct(
                  context: context,
                  productUuid: product.uuid,
                  productId: product.id.toString(),
                  accountId: "1",
                  action: "activate",
                );
                onRefresh();
              }
            },
            itemBuilder: (context) {
              if (isActive) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'deactivate',
                    child: Row(
                      children: [
                        Icon(Icons.block, size: 18, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Deactivate'),
                      ],
                    ),
                  ),
                ];
              } else {
                return const [
                   PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'activate',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 18, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Activate'),
                      ],
                    ),
                  ),
                ];
              }
            },
          ),
        ],
      ),
    );
  }
}

