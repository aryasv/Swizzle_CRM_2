import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';

class CompaniesDetailsPage extends StatefulWidget {
  final int companyId;
  final String companyUuid;

  const CompaniesDetailsPage({
    super.key,
    required this.companyId,
    required this.companyUuid,
  });

  @override
  State<CompaniesDetailsPage> createState() => _CompaniesDetailsPageState();
}


class _CompaniesDetailsPageState extends State<CompaniesDetailsPage> {
  CompanyDetailsModel? company;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    final api = WebFunctions();

    final response = await api.companyDetails(
      context: context,
      companyUuid: widget.companyUuid,
      companyId: widget.companyId,
    );


    if (!mounted) return;

    if (response.result) {
      company = CompanyDetailsModel.fromJson(
        response.response!['data'],
      );
    }

    setState(() => isLoading = false);
  }

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
              width: 40,
              height: 40,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert, size: 22),
                offset: const Offset(0, 40),
                onSelected: (v) {
                  if (v == 'edit') {
                    // TODO: Navigate to edit page
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : company == null
                ? const Center(child: Text('Failed to load company'))
                : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 72),
              child: Column(
                children: [
                  _companyHeader(company!),
                  const SizedBox(height: 16),

                  _section(
                    title: 'Company Information',
                    icon: Icons.info_outline,
                    children: [
                      _infoRow(Icons.business, 'Company Name', company!.name),
                      _infoRow(Icons.phone, 'Phone', company!.phone, isLink: true),
                      _infoRow(Icons.language, 'Website', company!.website, isLink: true),
                      _infoRow(Icons.email, 'Email', company!.email, isLink: true),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _section(
                    title: 'Address Information',
                    icon: Icons.location_on_outlined,
                    children: [
                      _infoRow(Icons.location_city, 'Address', company!.address),
                      _infoRow(Icons.location_city, 'City', company!.city),
                      _infoRow(Icons.pin_drop, 'Zip', company!.zip),
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

  // HEADER
  Widget _companyHeader(CompanyDetailsModel c) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  c.website,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SECTION
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

  // 
  Widget _infoRow(
      IconData icon,
      String label,
      String value, {
        bool isLink = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final leftWidth = constraints.maxWidth * 0.35;
          final rightWidth = constraints.maxWidth * 0.65;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF2A7DE1)),
              const SizedBox(width: 12),

              SizedBox(
                width: leftWidth - 30,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),

              SizedBox(
                width: rightWidth,
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
          );
        },
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
