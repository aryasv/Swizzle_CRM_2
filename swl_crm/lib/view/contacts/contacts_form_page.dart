import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/custom_app_bar.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class ContactsFormPage extends StatefulWidget {
  const ContactsFormPage({super.key});

  @override
  State<ContactsFormPage> createState() => _ContactsFormPageState();
}

class _ContactsFormPageState extends State<ContactsFormPage> {

  String? selectedCompany;

  final List<String> companies = [
    'TechCorp Solutions',
    'Innovate Labs',
    'DataFlow Systems',
    'Global Ventures',
  ];


  bool contactExpanded = true;
  bool addressExpanded = false;


  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController homePhone = TextEditingController();
  final TextEditingController description = TextEditingController();

  final TextEditingController street = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController zip = TextEditingController();

  bool emailOptOut = false;

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    title.dispose();
    email.dispose();
    phone.dispose();
    mobile.dispose();
    homePhone.dispose();
    description.dispose();
    street.dispose();
    city.dispose();
    state.dispose();
    country.dispose();
    zip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Add New Contact',
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Contact Information
                  _buildAccordion(
                    title: 'Contact Information',
                    isExpanded: contactExpanded,
                    onTap: () {
                      setState(() => contactExpanded = !contactExpanded);
                    },
                    child: Column(
                      children: [
                        _field('First Name', firstName, 'Enter first name'),
                        _field('Last Name', lastName, 'Enter last name'),
                        _field('Title', title, 'Enter title'),
                        _field('Email', email, 'Enter email',
                            keyboard: TextInputType.emailAddress),
                        _field('Phone', phone, 'Enter phone',
                            keyboard: TextInputType.phone),
                        _companyDropdown(),
                        _field('Mobile', mobile, 'Enter mobile',
                            keyboard: TextInputType.phone),
                        _field('Home Phone', homePhone, 'Enter home phone',
                            keyboard: TextInputType.phone),

                        // Email Check box
                        Row(
                          children: [
                            Transform.translate(
                              offset: const Offset(-8, 0),
                              child: Checkbox(
                                value: emailOptOut,
                                onChanged: (val) {
                                  setState(() => emailOptOut = val ?? false);
                                },
                              ),
                            ),
                            const Text('Email Opt Out'),
                          ],
                        ),

                        _field(
                          'Description',
                          description,
                          'Enter description',
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address Information
                  _buildAccordion(
                    title: 'Address Information',
                    isExpanded: addressExpanded,
                    onTap: () {
                      setState(() => addressExpanded = !addressExpanded);
                    },
                    child: Column(
                      children: [
                        _field('Mailing Street', street,
                            'Enter mailing street'),
                        _field('Mailing City', city, 'Enter mailing city'),
                        _field('Mailing State', state, 'Enter mailing state'),
                        _field(
                            'Mailing Country', country, 'Enter mailing country'),
                        _field('Mailing Zip', zip, 'Enter mailing zip',
                            keyboard: TextInputType.number),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  //  Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffffffff),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A7DE1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                              Icons.check,
                            color: Colors.white,

                          ),
                          label: const Text(
                              'Save Contact',
                            style: TextStyle(color: Colors.white),

                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 48,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UI

  Widget _buildAccordion({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
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
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.folder_open, color: Color(0xFF2A7DE1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller,
      String hint, {
        TextInputType keyboard = TextInputType.text,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          // Validation placeholder
          const SizedBox(height: 4),
          // Example:
          // Text('This field is required',
          //   style: TextStyle(color: Colors.red, fontSize: 12),
          // ),
        ],
      ),
    );
  }

  Widget _companyDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Company',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedCompany,
            items: companies.map((company) {
              return DropdownMenuItem<String>(
                value: company,
                child: Text(company),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCompany = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select an option',
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
          ),


        ],
      ),
    );
  }

}
