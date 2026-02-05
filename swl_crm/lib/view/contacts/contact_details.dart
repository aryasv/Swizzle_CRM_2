import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class ContactDetailsPage extends StatefulWidget {
  const ContactDetailsPage({super.key});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {

  @override
  void initState() {
    super.initState();
    _testApi();
  }

  Future<void> _testApi() async {
    final api = WebFunctions();

    final response = await api.contactDetails(
      context: context,
      clientUuid: "CLIENT_UUID",
      clientId: 12,
    );

    if (!mounted) return;

    if (response.result) {
      debugPrint("Contact Details API RESPONSE:");
      debugPrint(response.response.toString());
    } else {
      debugPrint("Contact Details API ERROR:");
      debugPrint(response.error);
    }
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
                  _contactHeader(),
                  const SizedBox(height: 16),

                  _section(
                    title: 'Contact Information',
                    icon: Icons.info_outline,
                    children: [
                      _infoRow(Icons.person_outline, 'First Name', 'Arya Swizzle'),
                      _infoRow(Icons.person_outline, 'Last Name', 'Arya'),
                      _infoRow(Icons.email_outlined, 'Email', 'arya@swizzleup.com', isLink: true),
                      _infoRow(Icons.phone_outlined, 'Phone', '9867676787', isLink: true),
                      _infoRow(Icons.apartment_outlined, 'Company', 'Acme Corporation Updated', isLink: true),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _section(
                    title: 'Description',
                    icon: Icons.description_outlined,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'test description',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _section(
                    title: 'Other Info',
                    icon: Icons.info_outline,
                    children: [
                      _infoRow(Icons.badge_outlined, 'Title', 'test'),
                      _infoRow(Icons.phone_android_outlined, 'Mobile', '897655555', isLink: true),
                      _infoRow(Icons.phone_outlined, 'Home Phone', '5567778889', isLink: true),
                      _infoRow(Icons.mark_email_read_outlined, 'Email Opt Out', '1'),
                      _infoRow(Icons.location_on_outlined, 'Mailing Street', '123 street'),
                      _infoRow(Icons.location_city_outlined, 'Mailing City', '123 city'),
                      _infoRow(Icons.map_outlined, 'Mailing State', '123 state'),
                      _infoRow(Icons.public_outlined, 'Mailing Country', '123 country'),
                      _infoRow(Icons.local_post_office_outlined, 'Mailing Zip', '123456'),
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

  Widget _contactHeader() {
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
            child: const Center(
              child: Text(
                'AS',
                style: TextStyle(
                  color: Color(0xFF2A7DE1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Arya Swizzle Arya',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                'Acme Corporation Updated',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //

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

  //

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
