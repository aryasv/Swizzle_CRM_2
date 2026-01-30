import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/products_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  final WebFunctions _api = WebFunctions();

  late TabController _tabController;

  bool isLoading = true;

  List<ProductModel> activeProducts = [];
  List<ProductModel> inactiveProducts = [];

  int activeCount = 0;
  int inactiveCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => isLoading = true);

    final activeRes = await _api.products(
      context: context,
      status: "active",
    );

    final inactiveRes = await _api.products(
      context: context,
      status: "inactive",
    );

    if (!mounted) return;

    if (activeRes.result && inactiveRes.result) {
      final activeData = activeRes.response!['data'];
      final inactiveData = inactiveRes.response!['data'];

      activeProducts = (activeData['products'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList()
          ..sort((a, b) => b.id.compareTo(a.id));

      inactiveProducts = (inactiveData['products'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList()
          ..sort((a, b) => b.id.compareTo(a.id));

      activeCount = activeData['active_count'] ?? activeProducts.length;
      inactiveCount = inactiveData['inactive_count'] ?? inactiveProducts.length;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Products',
            showBack: true,
          ),

          CustomTabBar(
            controller: _tabController,
            tabs: [
              CustomTabItem(label: 'Active', count: activeCount),
              CustomTabItem(label: 'Inactive', count: inactiveCount),
            ],
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                ProductsList(
                  products: activeProducts,
                  isActive: true,
                  onRefresh: _loadProducts,
                ),
                ProductsList(
                  products: inactiveProducts,
                  isActive: false,
                  onRefresh: _loadProducts,
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductsCreatePage(),
            ),
          ).then((v) {
            if (v == true) _loadProducts();
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

