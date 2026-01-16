import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Custom AppBar with back
          CustomAppBar(
            title: 'Products',
            showBack: true,
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,

                labelColor: const Color(0xFF2A7DE1),
                unselectedLabelColor: Colors.grey,

                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),

                indicatorColor: const Color(0xFF2A7DE1),
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,

                tabs: const [
                  Tab(text: 'Active 2'),
                  Tab(text: 'Inactive 1'),
                ],
              ),
            ),
          ),

          // List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ProductsList(isActive: true),
                ProductsList(isActive: false),
              ],
            ),
          ),
        ],
      ),

      // Floating button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
