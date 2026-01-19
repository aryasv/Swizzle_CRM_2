import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  // Static list
  static final List<Map<String, String>> _contacts = [
    {
      'name': 'John Smith',
      'company': 'TechCorp Solutions',
      'email': 'john.smith@techcorp.com',
      'phone': '+1 (555) 123-4567',
      'initials': 'JS',
    },
    {
      'name': 'Sarah Johnson',
      'company': 'Innovate Labs',
      'email': 'sarah.j@innovate.io',
      'phone': '+1 (555) 234-5678',
      'initials': 'SJ',
    },
    {
      'name': 'Michael Chen',
      'company': 'DataFlow Systems',
      'email': 'm.chen@dataflow.com',
      'phone': '+1 (555) 345-6789',
      'initials': 'MC',
    },
    {
      'name': 'Emily Rodriguez',
      'company': 'Global Ventures Inc',
      'email': 'emily.r@globalventures.com',
      'phone': '+1 (555) 456-7890',
      'initials': 'ER',
    },
    {
      'name': 'David Park',
      'company': 'CloudNine Technologies',
      'email': 'david.park@cloudnine.tech',
      'phone': '+1 (555) 567-8901',
      'initials': 'DP',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final c = _contacts[index];
        return _ContactCard(
          name: c['name']!,
          company: c['company']!,
          email: c['email']!,
          phone: c['phone']!,
          initials: c['initials']!,
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String name;
  final String company;
  final String email;
  final String phone;
  final String initials;

  const _ContactCard({
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
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
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFE8F1FD),
            child: Text(
              initials,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A7DE1),
              ),
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
                _InfoRow(Icons.business, company),
                const SizedBox(height: 4),
                _InfoRow(Icons.email_outlined, email),
                const SizedBox(height: 4),
                _InfoRow(Icons.phone_outlined, phone),
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
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
