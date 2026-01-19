import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class CompaniesList extends StatelessWidget {
  const CompaniesList({super.key});

  // Static List
  static final List<Map<String, String>> _companies = [
    {
      'name': 'TechCorp Solutions',
      'phone': '+1 (555) 100-1000',
      'website': 'www.techcorp.com',
      'initials': 'TC',
    },
    {
      'name': 'Innovate Labs Inc',
      'phone': '+1 (555) 200-2000',
      'website': 'www.innovatelabs.io',
      'initials': 'IL',
    },
    {
      'name': 'DataFlow Systems',
      'phone': '+1 (555) 300-3000',
      'website': 'www.dataflow.com',
      'initials': 'DS',
    },
    {
      'name': 'Global Ventures Inc',
      'phone': '+1 (555) 400-4000',
      'website': 'www.globalventures.com',
      'initials': 'GV',
    },
    {
      'name': 'CloudNine Technologies',
      'phone': '+1 (555) 500-5000',
      'website': 'www.cloudnine.tech',
      'initials': 'CN',
    },
    {
      'name': 'DigitalPro Media',
      'phone': '+1 (555) 700-7000',
      'website': 'www.digitalpro.net',
      'initials': 'DM',
    },
    {
      'name': 'FinTech Solutions Ltd',
      'phone': '+1 (555) 800-8000',
      'website': 'www.fintechsolutions.com',
      'initials': 'FS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _companies.length,
      itemBuilder: (context, index) {
        final c = _companies[index];
        return _CompanyCard(
          name: c['name']!,
          phone: c['phone']!,
          website: c['website']!,
          initials: c['initials']!,
        );
      },
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final String name;
  final String phone;
  final String website;
  final String initials;

  const _CompanyCard({
    required this.name,
    required this.phone,
    required this.website,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.apartment_outlined,
              color: Color(0xFF2A7DE1),
            ),
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                _InfoRow(Icons.phone_outlined, phone),
                const SizedBox(height: 4),
                _InfoRow(Icons.language, website),
              ],
            ),
          ),

          // Menu
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            child: const Icon(Icons.more_vert, size: 20),
            onSelected: (value) {
              debugPrint('$value clicked for $name');
            },
            itemBuilder: (context) => const [
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
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
