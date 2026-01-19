import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
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
          // AppBar
          const CustomAppBar(
            title: 'Contacts',
            showBack: true,
          ),

          // Tabs
          CustomTabBar(
            controller: _tabController,
            tabs: const [
              CustomTabItem(label: 'Active', count: 15),
              CustomTabItem(label: 'Inactive', count: 5),
            ],
          ),

          // List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ContactsList(),
                ContactsList(),
              ],
            ),
          ),
        ],
      ),

      // Add contact
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
