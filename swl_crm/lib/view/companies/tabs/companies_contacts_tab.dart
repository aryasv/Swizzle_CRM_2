import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';

import 'package:swl_crm/view/models/companies_details_contacts_model.dart';

class CompaniesContactsTab extends StatefulWidget {
  final CompanyDetailsModel? company;
  final String menuType;

  const CompaniesContactsTab({
    super.key,
    this.company,
    required this.menuType,
  });

  @override
  State<CompaniesContactsTab> createState() => _CompaniesContactsTabState();
}

class _CompaniesContactsTabState extends State<CompaniesContactsTab> {
  final List<CompanyDetailsContactsModel> _contacts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (widget.company == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final api = WebFunctions();
    final response = await api.getCompanyContacts(
      context: context,
      companyUuid: widget.company!.uuid,
      companyId: widget.company!.id,
      menuType: widget.menuType,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (response.result && response.response != null) {
        final data = response.response!['data'];
        
        List<dynamic>? contactsData;
        if (data != null) {
          if (data['contacts'] != null && data['contacts'] is List) {
             contactsData = data['contacts'];
          } else if (data['clients'] != null && data['clients'] is List) {
             contactsData = data['clients'];
          } else if (data['contact'] != null && data['contact'] is List) {
             contactsData = data['contact'];
          } else if (data['data'] != null && data['data'] is List) {
             contactsData = data['data'];
          } else if (data is List) {
             contactsData = data;
          }
        }

        if (contactsData != null) {
          _contacts.clear();
          _contacts.addAll(
            contactsData.map((e) => CompanyDetailsContactsModel.fromJson(e)).toList(),
          );
        }
      } else {
        _error = response.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_contacts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No contacts available',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }


    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _contacts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return _ContactItem(contact: contact);
      },
    );
  }
}

class _ContactItem extends StatelessWidget {
  final CompanyDetailsContactsModel contact;

  const _ContactItem({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF2A7DE1),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                if (contact.phone.isNotEmpty)
                  Text(
                    contact.phone,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                if (contact.email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    contact.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
