import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_model.dart';

class CompaniesFormPage extends StatefulWidget {
  final CompanyModel? company;

  const CompaniesFormPage({
    super.key,
    this.company,
  });

  @override
  State<CompaniesFormPage> createState() => _CompaniesFormPageState();
}

class _CompaniesFormPageState extends State<CompaniesFormPage> {
  bool get isEdit => widget.company != null;

  bool isSaving = false;
  bool isLoadingDetails = false;

  bool companyExpanded = true;
  bool addressExpanded = false;
  bool additionalExpanded = false;


  final TextEditingController companyName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController website = TextEditingController();
  final TextEditingController email = TextEditingController();

  final TextEditingController street = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController zip = TextEditingController();
  final TextEditingController billingCode = TextEditingController();

  final TextEditingController cfText = TextEditingController();
  final TextEditingController cfPicklist = TextEditingController();
  DateTime? cfDate;
  String? cfLookup;

  @override
  void dispose() {
    companyName.dispose();
    phone.dispose();
    website.dispose();
    email.dispose();
    street.dispose();
    city.dispose();
    state.dispose();
    country.dispose();
    zip.dispose();
    billingCode.dispose();
    cfText.dispose();
    cfPicklist.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if (isEdit && isLoadingDetails) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CustomAppBar(
            title: isEdit ? 'Edit Company' : 'New Company',
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  _accordion(
                    title: 'Company Information',
                    expanded: companyExpanded,
                    onTap: () =>
                        setState(() => companyExpanded = !companyExpanded),
                    child: Column(
                      children: [
                        _field('Company Name', companyName, 'Enter company name'),
                        _field('Phone', phone, 'Enter phone'),
                        _field('Website', website, 'Enter website'),
                        _field('Email', email, 'Enter email'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _accordion(
                    title: 'Address Information',
                    expanded: addressExpanded,
                    onTap: () =>
                        setState(() => addressExpanded = !addressExpanded),
                    child: Column(
                      children: [
                        _field(
                            'Billing Street',
                            street,
                            'Enter billing street',
                            maxLines: 3
                        ),
                        _field('Billing City', city, 'Enter billing city'),
                        _field('Billing State', state, 'Enter billing state'),
                        _field(
                            'Billing Country', country, 'Enter billing country'),
                        _field('Billing Zip', zip, 'Enter billing zip'),
                        _field('Billing Code', billingCode,
                            'Enter billing code'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),


                  _accordion(
                    title: 'Additional Information',
                    expanded: additionalExpanded,
                    onTap: () =>
                        setState(() => additionalExpanded = !additionalExpanded),
                    child: Column(
                      children: [
                        _field('CF - Text', cfText, 'Enter cf - text'),

                        _dateField(),

                        _field(
                            'CF - Picklist', cfPicklist, 'Enter cf - picklist'),

                        _lookupDropdown(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: isSaving ? null : () {

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A7DE1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isEdit ? 'Update Company' : 'Create Company',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _accordion({
    required String title,
    required bool expanded,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            cursorColor: const Color(0xFF2A7DE1),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Colors.black12, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF2A7DE1),
                  width: 1.5,
                ),
              ),
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

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CF - Date',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => cfDate = picked);
              }
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    cfDate == null
                        ? 'Select cf - date'
                        : cfDate!.toIso8601String().split('T').first,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lookupDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CF - Lookup',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: cfLookup,
            items: const [
              DropdownMenuItem(value: '1', child: Text('Option 1')),
              DropdownMenuItem(value: '2', child: Text('Option 2')),
            ],
            onChanged: (v) => setState(() => cfLookup = v),
            decoration: InputDecoration(
              hintText: 'Select cf - lookup',
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
