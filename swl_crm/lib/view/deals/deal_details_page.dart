import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class DealDetailsPage extends StatefulWidget {
  const DealDetailsPage({super.key});

  @override
  State<DealDetailsPage> createState() => _DealDetailsPageState();
}

class _DealDetailsPageState extends State<DealDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [

          // APPBAR
          CustomAppBar(
            title: 'Deal Details',
            showBack: true,
            rightAction1: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert, size: 22),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 60),
              child: Column(
                children: [

                  // HEADER
                  _header(),

                  const SizedBox(height: 16),

                  // BASIC INFO
                  _section(
                    title: 'Basic Info',
                    icon: Icons.info_outline,
                    children: [
                      _infoRow(Icons.person_outline, 'Contact', 'Lekshmi s Kumar', isLink: true),
                      _infoRow(Icons.business_outlined, 'Company', 'Swizzle'),
                      _infoRow(Icons.currency_rupee, 'Amount', '₹ 25,000.00'),
                      _infoRow(Icons.calendar_month, 'Closing Date', '02/19/2026'),
                      _infoRow(Icons.person_outline, 'Assigned To', 'Kiran Karma'),
                      _infoRow(Icons.flag_outlined, 'Status', 'Open'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // AUDIT
                  _section(
                    title: 'Audit',
                    icon: Icons.history,
                    children: [
                      _infoRow(Icons.person_add_alt, 'Created', 'Unknown'),
                      _infoRow(Icons.update, 'Updated', 'Unknown'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER CARD
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money, color: Color(0xFF2A7DE1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Deal - Deal For Swizzle',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Open',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION
  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF2A7DE1)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  // INFO ROW 
  Widget _infoRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isLink ? const Color(0xFF2A7DE1) : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6),
      ],
    );
  }
}
