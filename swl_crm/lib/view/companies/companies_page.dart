import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_model.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final WebFunctions _api = WebFunctions();

  bool isLoading = false;

  List<CompanyModel> activeCompanies = [];
  List<CompanyModel> inactiveCompanies = [];

  int activeCount = 0;
  int inactiveCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));

    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() => isLoading = true);

    // ACTIVE
    final activeResponse = await _api.companies(
      context: context,
      status: 'active',
      page: 1,
    );

    // INACTIVE
    final inactiveResponse = await _api.companies(
      context: context,
      status: 'inactive',
      page: 1,
    );

    if (!mounted) return;

    if (activeResponse.result && activeResponse.response != null) {
      final data = activeResponse.response!['data'];

      activeCount = data['active_count'] ?? 0;

      final List list = data['company'] ?? [];

      activeCompanies = list
          .map((e) => CompanyModel.fromListJson(e))
          .toList();
    }

    if (inactiveResponse.result && inactiveResponse.response != null) {
      final data = inactiveResponse.response!['data'];

      inactiveCount = data['inactive_count'] ?? 0;

      final List list = data['company'] ?? [];

      inactiveCompanies = list
          .map((e) => CompanyModel.fromListJson(e))
          .toList();
    }

    setState(() => isLoading = false);
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
          const CustomAppBar(
            title: 'Companies',
            showBack: true,
          ),

          CustomTabBar(
            controller: _tabController,
            tabs: [
              CustomTabItem(label: 'Active', count: activeCompanies.length),
              CustomTabItem(label: 'Inactive', count: inactiveCompanies.length),
            ],
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                CompaniesList(
                  companies: activeCompanies,
                  isActiveTab: true,
                  onRefresh: _loadCompanies,
                ),
                CompaniesList(
                  companies: inactiveCompanies,
                  isActiveTab: false,
                  onRefresh: _loadCompanies,
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () {

        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
