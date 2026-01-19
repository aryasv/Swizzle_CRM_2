import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class NavHome extends StatelessWidget {
  const NavHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: const [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Sarah Johnson',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Sales Manager',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFE8F1FD),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF2A7DE1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              //  Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome back, Sarah Johnson!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.business, size: 14, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          'Swizzle Innovations',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.verified_user,
                            size: 14, color: Color(0xFF2A7DE1)),
                        SizedBox(width: 4),
                        Text(
                          'Sales Manager',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Monday, January 5, 2026',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Grid Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: const [
                  _StatCard(
                    icon: Icons.inventory_2_outlined,
                    iconBg: Color(0xFFE8F1FD),
                    iconColor: Color(0xFF2A7DE1),
                    value: '30',
                    label: 'Total Products',
                  ),
                  _StatCard(
                    icon: Icons.apartment_outlined,
                    iconBg: Color(0xFFE8F6E8),
                    iconColor: Colors.green,
                    value: '50',
                    label: 'Total Companies',
                  ),
                  _StatCard(
                    icon: Icons.people_outline,
                    iconBg: Color(0xFFFFF3CD),
                    iconColor: Colors.orange,
                    value: '50',
                    label: 'Total Contacts',
                  ),
                  _StatCard(
                    icon: Icons.check_circle_outline,
                    iconBg: Color(0xFFFCE4EC),
                    iconColor: Colors.pink,
                    value: '20',
                    label: 'Total Tasks',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //  Account Information
              const _SectionTitle(title: 'Account Information'),

              _InfoBlock(
                items: const [
                  _InfoItem(
                      label: 'Account Name',
                      value: 'Swizzle Innovations'
                  ),
                  _InfoItem(
                    label: 'Currency',
                    value: '₹ INR (Indian Rupee)',
                  ),
                  _InfoItem(
                    label: 'Total Team Members',
                    value: '5 Users',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //  Team Overview
              const _SectionTitle(title: 'Team Overview'),

              _InfoBlock(
                items: const [
                  _InfoItem(
                      label: 'Account Admins',
                      value: '0'
                  ),
                  _InfoItem(
                      label: 'Staff Members',
                      value: '5'
                  ),
                ],
                trailingIcons: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final List<_InfoItem> items;
  final bool trailingIcons;

  const _InfoBlock({
    required this.items,
    this.trailingIcons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (trailingIcons)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.group,
                      color: Color(0xFF2A7DE1),
                      size: 18,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });
}

