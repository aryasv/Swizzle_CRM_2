import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_model.dart';

class CompaniesList extends StatelessWidget {
  final List<CompanyModel> companies;
  final bool isActiveTab;
  final VoidCallback onRefresh;

  const CompaniesList({
    super.key,
    required this.companies,
    required this.isActiveTab,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const Center(
        child: Text(
          'No companies found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        return _CompanyCard(
          company: companies[index],
          isActiveTab: isActiveTab,
          onRefresh: onRefresh,
        );
      },
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyModel company;
  final bool isActiveTab;
  final VoidCallback onRefresh;

  const _CompanyCard({
    required this.company,
    required this.isActiveTab,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final api = WebFunctions();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                _InfoRow(Icons.phone_outlined, company.phone),
                const SizedBox(height: 4),
                _InfoRow(Icons.language, company.website),
              ],
            ),
          ),

          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            child: const Icon(Icons.more_vert, size: 20),
            onSelected: (value) async {
              if (value == 'edit') {

              }

              if (value == 'deactivate') {
                await api.deleteCompany(
                  context: context,
                  companyUuid: company.uuid,
                  companyId: company.id,
                );
                onRefresh();
              }

              if (value == 'activate') {
                await api.deleteCompany(
                  context: context,
                  companyUuid: company.uuid,
                  companyId: company.id,
                  action: 'activate',
                );
                onRefresh();
              }
            },
            itemBuilder: (context) {
              if (isActiveTab) {
                return const [
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
                    value: 'deactivate',
                    child: Row(
                      children: [
                        Icon(Icons.block, size: 18, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Deactivate'),
                      ],
                    ),
                  ),
                ];
              } else {
                return const [
                  PopupMenuItem(
                    value: 'activate',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 18, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Activate'),
                      ],
                    ),
                  ),
                ];
              }
            },
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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
