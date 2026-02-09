import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class DealFormPage extends StatefulWidget {
  const DealFormPage({super.key});

  @override
  State<DealFormPage> createState() => _DealFormPageState();
}

class _DealFormPageState extends State<DealFormPage> {

  final TextEditingController _dealName = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String? _company;
  String? _contact;
  String? _stage;
  String? _closingDate;
  String? _devCompletionDate;

  final List<String> _companies = ['Acme Corp', 'Deepaks Company'];
  final List<String> _contacts = ['Arya Swizzle', 'Jonas Fry'];
  final List<String> _stages = ['Prospect', 'Negotiation', 'Closed Won'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [

          /// APP BAR
          const CustomAppBar(
            title: 'Create Deal',
            showBack: true,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 16),

                  //DEAL INFORMATION
                  const Text(
                    'Deal Information',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _field(
                    hint: 'Deal Name',
                    controller: _dealName,
                  ),

                  _dropdown(
                    hint: 'Company Name',
                    value: _company,
                    items: _companies,
                    onChanged: (v) => setState(() => _company = v),
                  ),

                  _dropdown(
                    hint: 'Contact Name',
                    value: _contact,
                    items: _contacts,
                    onChanged: (v) => setState(() => _contact = v),
                  ),

                  _dropdown(
                    hint: 'Stage',
                    value: _stage,
                    items: _stages,
                    onChanged: (v) => setState(() => _stage = v),
                  ),

                  _field(
                    hint: 'Amount',
                    controller: _amount,
                    keyboardType: TextInputType.number,
                  ),

                  _dateField(
                    label: 'Closing Date',
                    value: _closingDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        setState(() {
                          _closingDate =
                          "${date.day}/${date.month}/${date.year}";
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  _multilineField(
                    hint: 'Description',
                    controller: _description,
                  ),

                  const SizedBox(height: 24),

                  //ADDITIONAL INFORMATION
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _dateField(
                    label: 'Dev completion date',
                    value: _devCompletionDate,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        setState(() {
                          _devCompletionDate =
                          "${date.day}/${date.month}/${date.year}";
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// BUTTON
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 50),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A7DE1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Create Deal',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  Widget _field({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(hint),
      ),
    );
  }

  //
  Widget _multilineField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: _inputDecoration(hint),
      ),
    );
  }

  //
  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: _inputDecoration(hint),
      ),
    );
  }

  //
  Widget _dateField({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextField(
            decoration: _inputDecoration(label).copyWith(
              hintText: value ?? 'Select $label',
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2A7DE1)),
      ),
    );
  }
}
