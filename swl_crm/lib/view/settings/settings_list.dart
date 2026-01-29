import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/settings_model.dart';

class SettingsList extends StatelessWidget {
  final List<SettingsItemModel> items;

  const SettingsList({super.key, required this.items});

  void _handleTap(BuildContext context, String type) {
    switch (type) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;

      case 'products':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductsPage()),
        );
        break;

      case 'companies':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompaniesPage()),
        );
        break;

      case 'contacts':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ContactsPage()),
        );
        break;

      case 'about':

        break;

      case 'logout':

        break;

      case 'delete_account':
      
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return InkWell(
          onTap: () => _handleTap(context, item.type),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(item.icon, width: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}


