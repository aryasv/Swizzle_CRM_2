import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';

class CompaniesContactsTab extends StatelessWidget {
  final CompanyDetailsModel? company;

  const CompaniesContactsTab({super.key, this.company});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> staticContacts = [
      {
        'name': 'Test name',
        'phone': '06738238888',
        'email': 'test@icwares.com',
      },
      {
        'name': 'Test name',
        'phone': '06738238888',
        'email': 'test@icwares.com',
      },
      {
        'name': 'Test name',
        'phone': '06738238888',
        'email': 'test@icwares.com',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: staticContacts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final contact = staticContacts[index];
        return _ContactItem(
          name: contact['name']!,
          phone: contact['phone']!,
          email: contact['email']!,
        );
      },
    );
  }
}

class _ContactItem extends StatelessWidget {
  final String name;
  final String phone;
  final String email;

  const _ContactItem({
    required this.name,
    required this.phone,
    required this.email,
  });

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
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600, 
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
