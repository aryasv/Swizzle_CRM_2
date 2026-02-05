import 'package:flutter/material.dart';
import 'package:swl_crm/view/models/contacts_model.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class ContactsList extends StatelessWidget {
  final List<ContactModel> contacts;
  final VoidCallback onRefresh;
  final bool isActiveTab;

  const ContactsList({
    super.key,
    required this.contacts,
    required this.onRefresh,
    required this.isActiveTab,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const Center(
        child: Text(
          'No contacts found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];

        return _ContactCard(
          contact: contact,
          onRefresh: onRefresh,
          isActiveTab: isActiveTab,
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onRefresh;
  final bool isActiveTab;

  const _ContactCard({
    required this.contact,
    required this.onRefresh,
    required this.isActiveTab,
  });

  Future<bool> _confirmAction(
      BuildContext context,
      String title,
      String message,
      ) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _showSnack(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactDetailsPage(
              contactId: contact.id,
              contactUuid: contact.uuid,
            ),
          ),
        );
        onRefresh(); 
      },
      child: Container(
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
                contact.initials,
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
                    contact.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(Icons.business, contact.companyName),
                  const SizedBox(height: 4),
                  _InfoRow(Icons.email_outlined, contact.email),
                  const SizedBox(height: 4),
                  _InfoRow(Icons.phone_outlined, contact.phone),
                ],
              ),
            ),

            // Menu
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              child: const Icon(Icons.more_vert, size: 20),
              onSelected: (value) async {
                final api = WebFunctions();

                // EDIT
                if (value == 'edit') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContactsFormPage(contact: contact),
                    ),
                  );

                  if (result == true) {
                    onRefresh();
                  }
                }

                // DEACTIVATE
                if (value == 'deactivate') {
                  final confirmed = await _confirmAction(
                    context,
                    'Deactivate Contact',
                    'Are you sure you want to deactivate this contact?',
                  );

                  if (!confirmed) return;

                  final response = await api.deleteContact(
                    context: context,
                    clientUuid: contact.uuid,
                    clientId: contact.id,
                    action: 'deactivate',
                  );

                  if (!context.mounted) return;

                  if (response.result) {
                    _showSnack(context, 'Contact deactivated');
                    onRefresh();
                  } else {
                    _showSnack(context, response.error, isError: true);
                  }
                }

                // ACTIVATE
                if (value == 'activate') {
                  final confirmed = await _confirmAction(
                    context,
                    'Activate Contact',
                    'Do you want to activate this contact?',
                  );

                  if (!confirmed) return;

                  final response = await api.deleteContact(
                    context: context,
                    clientUuid: contact.uuid,
                    clientId: contact.id,
                    action: 'activate',
                  );

                  if (!context.mounted) return;

                  if (response.result) {
                    _showSnack(context, 'Contact activated');
                    onRefresh();
                  } else {
                    _showSnack(context, response.error, isError: true);
                  }
                }
              },

              itemBuilder: (context) {
                if (isActiveTab) {
                  // ACTIVE TAB MENU
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
                  // INACTIVE TAB MENU
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

