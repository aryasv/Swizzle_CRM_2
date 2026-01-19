import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  // Static list
  static final List<_SettingItem> _items = [
    _SettingItem(
      icon: Icons.person_outline,
      title: 'My Profile',
      subtitle: 'View and edit your profile',
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          ),
        );
      },
    ),


    _SettingItem(
      icon: Icons.inventory_2_outlined,
      title: 'Products',
      subtitle: 'Manage your products',
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductsPage(),
          ),
        );
      },
    ),
    _SettingItem(
      icon: Icons.apartment_outlined,
      title: 'Companies',
      subtitle: 'View and manage companies',
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CompaniesPage(),
          ),
        );
      },
    ),
    _SettingItem(
      icon: Icons.contacts_outlined,
      title: 'Contacts',
      subtitle: 'Manage your contacts',
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ContactsPage(),
          ),
        );
      },
    ),
    _SettingItem(
      icon: Icons.info_outline,
      title: 'About App',
      subtitle: 'App version and information',
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          ),
        );
      },
    ),

  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ..._items.map(
              (item) => _SettingsTile(item: item),
        ),

        const SizedBox(height: 0),

        // Delete account
        const _DeleteAccountTile(),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final _SettingItem item;

  const _SettingsTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => item.onTap(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
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
              child: Icon(
                item.icon,
                color: const Color(0xFF2A7DE1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountTile extends StatelessWidget {
  const _DeleteAccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        debugPrint('Delete Account tapped');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEAEA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final void Function(BuildContext context) onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}


