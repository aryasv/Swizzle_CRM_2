import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/contacts_model.dart';

class ContactsFormPage extends StatefulWidget {

  final ContactModel? contact;

  const ContactsFormPage({
    super.key,
    this.contact,
  });

  @override
  State<ContactsFormPage> createState() => _ContactsFormPageState();
}

class _ContactsFormPageState extends State<ContactsFormPage> {
  final WebFunctions _api = WebFunctions();

  bool get isEdit => widget.contact != null;
  bool isSaving = false;
  bool contactExpanded = true;
  bool addressExpanded = false;

  int? selectedCompanyId;


  // Static List
  final Map<int, String> companies = {
    18: 'Ace Corporation',
  };


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


  Future<void> _saveContact() async {
    if (firstName.text.trim().isEmpty) {
      _showError('First name is required');
      return;
    }

    if (email.text.trim().isEmpty) {
      _showError('Email is required');
      return;
    }

    setState(() => isSaving = true);

    final Map<String, dynamic> payload = {
      "first_name": firstName.text.trim(),
      "last_name": lastName.text.trim(),
      "title": title.text.trim(),
      "email": email.text.trim(),
      "phone": phone.text.trim(),
      "company_id": selectedCompanyId,
      "mobile_phone": mobile.text.trim(),
      "home_phone": homePhone.text.trim(),
      "email_opt_out": emailOptOut ? "1" : "0",
      "description": description.text.trim(),
      "mailing_street": street.text.trim(),
      "mailing_city": city.text.trim(),
      "mailing_state": state.text.trim(),
      "mailing_country": country.text.trim(),
      "mailing_zip": zip.text.trim(),
    };

    late ApiResponse response;

    if (isEdit) {

      response = await _api.updateContact(
        context: context,
        clientUuid: widget.contact!.uuid,
        contactData: {
          "client_id": widget.contact!.id,
          ...payload,
        },
      );
    } else {

      response = await _api.storeContact(
        context: context,
        contactData: payload,
      );
    }

    if (!mounted) return;

    setState(() => isSaving = false);

    if (response.result) {
      Navigator.pop(context, true);
    } else {
      _showError(
        response.error.isNotEmpty
            ? response.error
            : 'Failed to save contact',
      );
    }
  }


  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final c = widget.contact!;
      firstName.text = c.name.split(' ').first;
      lastName.text =
      c.name.split(' ').length > 1 ? c.name.split(' ').last : '';
      email.text = c.email;
      phone.text = c.phone;
      selectedCompanyId = c.companyId;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CustomAppBar(
            title: isEdit ? 'Edit Contact' : 'Add New Contact',
            showBack: true,
          ),


          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAccordion(
                    title: 'Contact Information',
                    isExpanded: contactExpanded,
                    onTap: () =>
                        setState(() => contactExpanded = !contactExpanded),
                    child: Column(
                      children: [
                        _field('First Name', firstName, 'Enter first name'),
                        _field('Last Name', lastName, 'Enter last name'),
                        _field('Title', title, 'Enter title'),
                        _field('Email', email, 'Enter email'),
                        _field('Phone', phone, 'Enter phone'),
                        _companyDropdown(),
                        _field('Mobile', mobile, 'Enter mobile'),
                        _field('Home Phone', homePhone, 'Enter home phone'),
                        Row(
                          children: [
                            Transform.translate(
                              offset: const Offset(-8, 0),
                              child: Checkbox(
                                value: emailOptOut,
                                onChanged: (v) =>
                                    setState(() => emailOptOut = v ?? false),
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

                  _buildAccordion(
                    title: 'Address Information',
                    isExpanded: addressExpanded,
                    onTap: () =>
                        setState(() => addressExpanded = !addressExpanded),
                    child: Column(
                      children: [
                        _field('Street', street, 'Enter street'),
                        _field('City', city, 'Enter city'),
                        _field('State', state, 'Enter state'),
                        _field('Country', country, 'Enter country'),
                        _field('Zip', zip, 'Enter zip'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),



                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
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
                          onPressed: isSaving ? null : _saveContact,
                          icon: isSaving
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Icon(Icons.check, color: Colors.white,),
                          label: const Text(
                              'Save Contact',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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

  //

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
          BoxShadow(color: Colors.black12, blurRadius: 6),
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
                  const Icon(Icons.folder_open,
                      color: Color(0xFF2A7DE1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
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
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: selectedCompanyId,
            items: companies.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCompanyId = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select Company',
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

