import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class DealsList extends StatelessWidget {
  const DealsList({super.key});

  // Static List
  static final List<Map<String, String>> _deals = [
    {
      'title': 'Project Management Tool',
      'status': 'Open',
      'amount': '₹ 62,000.00',
    },
    {
      'title': 'Game Analytics Platform',
      'status': 'Open',
      'amount': '₹ 45,000.00',
    },
    {
      'title': 'Booking System',
      'status': 'Open',
      'amount': '₹ 38,000.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _deals.length,
      itemBuilder: (context, index) {
        final deal = _deals[index];
        return DealCard(
          title: deal['title']!,
          status: deal['status']!,
          amount: deal['amount']!,
        );
      },
    );
  }
}

class DealCard extends StatelessWidget {
  final String title;
  final String status;
  final String amount;

  const DealCard({
    Key? key,
    required this.title,
    required this.status,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          //  Title And menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  child: const Icon(Icons.more_vert, size: 24),
                  onSelected: (value) {},
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
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Name And Status
          Row(
            children: [
              const _InfoItem(label: 'Name', value: 'N/A'),
              const Spacer(),
              _StatusChip(status: status),
            ],
          ),

          const SizedBox(height: 16),

          //  Close Date And Amount
          Row(
            children: [
              const _InfoItem(label: 'Close Date', value: 'N/A'),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A7DE1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isOpen = status.toLowerCase() == 'open';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? const Color(0xFF2A7DE1)
            : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isOpen ? const Color(0xFFffffff) : const Color(0xFFffffff),
        ),
      ),
    );
  }
}
