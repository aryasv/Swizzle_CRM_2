import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/contact_details_model.dart';
import 'package:swl_crm/view/models/contacts_model.dart';

class ContactDetailsPage extends StatefulWidget {
  final int contactId;
  final String contactUuid;

  const ContactDetailsPage({
    super.key,
    required this.contactId,
    required this.contactUuid,
  });

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  ContactDetailsModel? contact;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    final api = WebFunctions();

    final response = await api.contactDetails(
      context: context,
      clientUuid: widget.contactUuid,
      clientId: widget.contactId,
    );

    if (!mounted) return;

    if (response.result) {
      contact = ContactDetailsModel.fromJson(response.response!['data']);
    } else {
      debugPrint("Contact Details API ERROR: ${response.error}");
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
            title: 'Contact Details',
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
                onSelected: (value) async {
                  if (value == 'edit' && contact != null) {

                      final contactModel = ContactModel(
                        id: contact!.id,
                        uuid: contact!.uuid,
                        name: contact!.fullName,
                        email: contact!.email,
                        phone: contact!.phone,
                        companyName: contact!.companyName,
                        isDeleted: false,
                      );

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactsFormPage(contact: contactModel),
                        ),
                      );

                      if (result == true) {
                        _loadContact();
                      }
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
                : contact == null
                    ? const Center(child: Text('Failed to load contact'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 72),
                        child: Column(
                          children: [
                            _contactHeader(contact!),
                            const SizedBox(height: 16),

                            _section(
                              title: 'Contact Information',
                              icon: Icons.info_outline,
                              children: [
                                _infoRow(Icons.person_outline, 'First Name', contact!.firstName),
                                _infoRow(Icons.person_outline, 'Last Name', contact!.lastName),
                                _infoRow(Icons.email_outlined, 'Email', contact!.email, isLink: true),
                                _infoRow(Icons.phone_outlined, 'Phone', contact!.phone, isLink: true),
                                _infoRow(Icons.apartment_outlined, 'Company', contact!.companyName, isLink: true),
                              ],
                            ),

                            const SizedBox(height: 16),


                            // _section(
                            //   title: 'Description',
                            //   icon: Icons.description_outlined,
                            //   children: const [
                            //     Padding(
                            //       padding: EdgeInsets.all(16),
                            //       child: Align(
                            //         alignment: Alignment.centerLeft,
                            //         child: Text(
                            //           'No description available',
                            //           style: TextStyle(fontSize: 14),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 16),

                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Widget _contactHeader(ContactDetailsModel c) {
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
            child: Center(
              child: Text(
                _getInitials(c.fullName),
                style: const TextStyle(
                  color: Color(0xFF2A7DE1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.fullName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                c.companyName,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
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

  Widget _infoRow(
      IconData icon,
      String label,
      String value, {
        bool isLink = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2A7DE1)),
          const SizedBox(width: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
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
