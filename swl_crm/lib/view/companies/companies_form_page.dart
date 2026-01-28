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
  final WebFunctions _api = WebFunctions();

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
  void initState() {
    super.initState();

    if (isEdit) {
      isLoadingDetails = true;
      _loadCompanyDetails();
    }
  }

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

  Future<void> _loadCompanyDetails() async {
    final response = await _api.editCompany(
      context: context,
      companyUuid: widget.company!.uuid,
      companyId: widget.company!.id,
      accountId: 1,
    );

    if (!mounted) return;

    if (!response.result || response.response == null) {
      isLoadingDetails = false;
      setState(() {});
      _showError('Failed to load company details');
      return;
    }

    final Map<String, dynamic> root =
    response.response!.containsKey('data')
        ? Map<String, dynamic>.from(response.response!['data'])
        : Map<String, dynamic>.from(response.response!);


    final company = root['company'];

    companyName.text = company['name'] ?? '';
    phone.text = company['phone'] ?? '';
    email.text = company['email'] ?? '';
    website.text = company['website'] ?? '';

    street.text = company['address'] ?? '';
    city.text = company['city'] ?? '';
    state.text = company['state'] ?? '';
    country.text = company['country'] ?? '';
    zip.text = company['zip'] ?? '';
    billingCode.text = company['billing_code'] ?? '';


    final List fieldsGroups = root['fields'] ?? [];
    final Map<String, dynamic> values = {};

    for (final group in fieldsGroups) {
      final List fields = group['fields'] ?? [];
      for (final field in fields) {
        values[field['name']] = field['current_value'];
      }
    }

    cfText.text = values['custom_field_66']?.toString() ?? '';
    cfPicklist.text = values['custom_field_68']?.toString() ?? '';
    cfLookup = values['custom_field_69']?.toString();


    if (values['custom_field_67'] != null &&
        values['custom_field_67'].toString().contains('-')) {
      final parts = values['custom_field_67'].toString().split('-');
      cfDate = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }

    isLoadingDetails = false;
    setState(() {});
  }


  Future<void> _saveCompany() async {
    if (companyName.text.trim().isEmpty) {
      _showError('Company name is required');
      return;
    }

    if (phone.text.trim().isEmpty) {
      _showError('Phone is required');
      return;
    }

    if (email.text.trim().isEmpty) {
      _showError('Email is required');
      return;
    }

    if (website.text.trim().isNotEmpty &&
        !website.text.trim().startsWith('http')) {
      _showError('Website must start with https://');
      return;
    }

    setState(() => isSaving = true);

    final Map<String, dynamic> payload = {
      "name": companyName.text.trim(),
      "phone": phone.text.trim(),
      "website": website.text.trim(),
      "email": email.text.trim(),
      "address": street.text.trim(),
      "city": city.text.trim(),
      "state": state.text.trim(),
      "country": country.text.trim(),
      "zip": zip.text.trim(),
      "billing_code": billingCode.text.trim(),
      "custom_field_68": "2",
      "custom_field_69": cfLookup ?? "",
    };

    if (cfText.text.isNotEmpty) {
      payload["custom_field_66"] = cfText.text.trim();
    }

    if (cfDate != null) {
      payload["custom_field_67"] =
      '${cfDate!.month.toString().padLeft(2, '0')}/'
          '${cfDate!.day.toString().padLeft(2, '0')}/'
          '${cfDate!.year}';
    }

    late ApiResponse response;

    if (isEdit) {
      response = await _api.updateCompany(
        context: context,
        companyUuid: widget.company!.uuid,
        companyData: payload,
      );
    } else {
      response = await _api.storeCompany(
        context: context,
        companyData: payload,
      );
    }

    if (!mounted) return;

    setState(() => isSaving = false);

    if (response.result) {
      Navigator.pop(context, true);
    } else {
      _showError(response.error);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  //
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
                        _field('Billing Street', street, 'Enter billing street',
                            maxLines: 3),
                        _field('Billing City', city, 'Enter billing city'),
                        _field('Billing State', state, 'Enter billing state'),
                        _field(
                            'Billing Country', country, 'Enter billing country'),
                        _field('Billing Zip', zip, 'Enter billing zip'),
                        _field('Billing Code', billingCode, 'Enter billing code'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _field('CF - Text', cfText, 'Enter cf - text'),
                        Text('CF - Date',
                            style:
                            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        _dateField(),
                        _field(
                            'CF - Picklist',
                            cfPicklist,
                            'Enter cf - picklist'),
                        Text('CF - Lookup',
                            style:
                            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        _lookupDropdown(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveCompany,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A7DE1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEdit ? 'Update Company' : 'Create Company',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  //
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
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
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Icon(expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
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

  Widget _field(String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              label,
              style:
              const TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w500)
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            cursorColor: const Color(0xFF2A7DE1),

            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black38,
                fontSize: 14,
              ),

              filled: true,
              fillColor: const Color(0xFFF9F9F9),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.black12,
                  width: 1,
                ),
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
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: cfDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) setState(() => cfDate = picked);
        },
        child: Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                cfDate == null
                    ? 'Select cf - date'
                    : cfDate!.toIso8601String().split('T').first,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),


              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lookupDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
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
    );
  }
}
