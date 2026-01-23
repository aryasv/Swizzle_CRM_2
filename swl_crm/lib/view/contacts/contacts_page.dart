import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/contacts_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final WebFunctions _api = WebFunctions();

  bool _isLoading = true;
  String _error = '';

  ContactsResponse? _activeContactsResponse;
  ContactsResponse? _inactiveContactsResponse;



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));

    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });

    // ACTIVE
    final activeResponse = await _api.contacts(
      context: context,
      status: "active",
      page: 1,
    );

    // INACTIVE
    final inactiveResponse = await _api.contacts(
      context: context,
      status: "inactive",
      page: 1,
    );

    if (!mounted) return;

    if (activeResponse.result && inactiveResponse.result) {
      setState(() {
        _activeContactsResponse =
            ContactsResponse.fromJson(activeResponse.response!);
        _inactiveContactsResponse =
            ContactsResponse.fromJson(inactiveResponse.response!);
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = activeResponse.error.isNotEmpty
            ? activeResponse.error
            : inactiveResponse.error;
        _isLoading = false;
      });
    }
  }


  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showError(_error);
      });
    }

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
            fontSize: 16,
            tabs: [
              CustomTabItem(
                label: 'Active',
                count: _activeContactsResponse?.contacts.length ?? 0,
              ),
              CustomTabItem(
                label: 'Inactive',
                count: _inactiveContactsResponse?.contacts.length ?? 0,
              ),
            ],
          ),



          // List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active contacts
                ContactsList(
                  contacts: _activeContactsResponse?.contacts ?? [],
                  onRefresh: _loadContacts,
                  isActiveTab: true,

                ),

                // Inactive contacts
                ContactsList(
                  contacts: _inactiveContactsResponse?.contacts ?? [],
                  onRefresh: _loadContacts,
                  isActiveTab: false,
                ),


              ],
            ),
          ),
          SizedBox(height: 48,)
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A7DE1),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ContactsFormPage(),
            ),
          );

          if (result == true) {
            _loadContacts();
          }
        },

        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


