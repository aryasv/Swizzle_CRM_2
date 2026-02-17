import 'package:flutter/material.dart';

import 'package:swl_crm/view/models/companies_details_model.dart';
import 'package:intl/intl.dart';

class CompaniesDealsTab extends StatefulWidget {
  final CompanyDetailsModel? company;
  const CompaniesDealsTab({super.key, this.company});

  @override
  State<CompaniesDealsTab> createState() => _CompaniesDealsTabState();
}

class _CompaniesDealsTabState extends State<CompaniesDealsTab> {

  final List<Map<String, dynamic>> _deals = [
    {
      'title': 'Event',
      'amount': 4000.00,
      'user_name': 'Anish V J',
      'date': '2026-02-17',
    },
    {
      'title': 'Event',
      'amount': 4000.00,
      'user_name': 'Anish V J',
      'date': '2026-02-17',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_deals.isEmpty) {
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
            Icon(Icons.monetization_on_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No deals available',
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
      itemCount: _deals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final deal = _deals[index];
        return _DealItem(deal: deal);
      },
    );
  }
}

class _DealItem extends StatelessWidget {
  final Map<String, dynamic> deal;

  const _DealItem({required this.deal});

  @override
  Widget build(BuildContext context) {
    // Format date
    String formattedDate = deal['date'];
    try {
      final date = DateTime.parse(deal['date']);
      formattedDate = DateFormat('MM/dd/yyyy').format(date);
    } catch (_) {}

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
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.handshake_outlined, color: Color(0xFF2A7DE1), size: 24),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal['title'] ?? 'Deal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${(deal['amount'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A7DE1),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      deal['user_name'] ?? '',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
