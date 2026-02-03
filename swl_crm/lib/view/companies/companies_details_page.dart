import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class CompaniesDetailsPage extends StatelessWidget {
  const CompaniesDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CustomAppBar(
            title: 'Company Details',
            showBack: true,
            rightAction1: SizedBox(
              height: 40,
              width: 40,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                icon: const Icon(Icons.more_vert, size: 22),
                offset: const Offset(0, 40),
                onSelected: (value) {
                  if (value == 'edit') {

                  }
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
                ],
              ),
            ),
          ),



          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 72),
              child: Column(
                children: [
                  _companyHeader(),
                  const SizedBox(height: 16),

                  _section(
                    title: 'Company Information',
                    icon: Icons.info_outline,
                    children: [
                      _infoRow(Icons.business, 'Company Name', 'Deepaks Company'),
                      _infoRow(Icons.phone, 'Phone', '9846464687', isLink: true),
                      _infoRow(Icons.language, 'Website', 'https://www.google.com/', isLink: true),
                      _infoRow(Icons.email, 'Email', 'deepak@gmail.com', isLink: true),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _section(
                    title: 'Address Information',
                    icon: Icons.location_on_outlined,
                    children: [
                      _infoRow(Icons.text_fields, 'Billing Street', '123 street\nBilling street'),
                      _infoRow(Icons.text_fields, 'Billing City', 'Trivandrum'),
                      _infoRow(Icons.text_fields, 'Billing State', 'Kerala'),
                      _infoRow(Icons.text_fields, 'Billing Country', 'India'),
                      _infoRow(Icons.text_fields, 'Billing Zip', '695308'),
                      _infoRow(Icons.text_fields, 'Billing Code', '123098'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _section(
                    title: 'Additional Information',
                    icon: Icons.info_outline,
                    children: [
                      _infoRow(Icons.text_fields, 'CF - Text', 'CF Billing'),
                      _infoRow(Icons.text_fields, 'CF - Date', '2026-01-28'),
                      _infoRow(Icons.text_fields, 'CF - Picklist', '2'),
                      _infoRow(Icons.text_fields, 'CF - Lookup', '2'),
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

  //
  Widget _companyHeader() {
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
            child: const Icon(Icons.apartment, color: Color(0xFF2A7DE1)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Deepaks Company',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                'https://www.google.com/',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }


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


  Widget _infoRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2A7DE1)),
          const SizedBox(width: 12),
          Expanded(
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
