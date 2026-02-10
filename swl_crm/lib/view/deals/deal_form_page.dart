import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/deal_details_model.dart';
import 'package:swl_crm/view/models/deals_model.dart';
import 'package:intl/intl.dart';

class DealFormPage extends StatefulWidget {
  final DealDetailsModel? deal;
  final DealModel? dealSummary;
  final int? dealId;
  final String? dealUuid;

  const DealFormPage({
    super.key,
    this.deal,
    this.dealSummary,
    this.dealId,
    this.dealUuid,
  });

  @override
  State<DealFormPage> createState() => _DealFormPageState();
}

class _DealFormPageState extends State<DealFormPage> {
  final TextEditingController _dealName = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _description = TextEditingController();

  // Store IDs
  int? _companyId;
  int? _contactId;
  int? _stageId;
  String? _closingDate;
  String? _devCompletionDate;

  // Data lists
  List<Map<String, dynamic>> _companies = [];
  List<Map<String, dynamic>> _contacts = [];
  
  // Static stages for now, mapped to IDs
  final List<Map<String, dynamic>> _stages = [
    {'id': 1, 'name': 'Prospect'},
    {'id': 2, 'name': 'Negotiation'},
    {'id': 3, 'name': 'Closed Won'},
    {'id': 4, 'name': 'Closed Lost'},
  ];

  bool _isLoading = false;
  bool _isFetchingDetails = true; // Renamed from _isInitializing

  bool get _isEditMode => widget.deal != null || widget.dealSummary != null || (widget.dealId != null && widget.dealUuid != null);
  DealDetailsModel? _fetchedDeal;
  DealDetailsModel? get _currentDeal => widget.deal ?? _fetchedDeal;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // Immediate pre-fill if data is available
    if (_isEditMode) {
      if (widget.deal != null) {
        _populateFormData(widget.deal!);
        _isFetchingDetails = false;
      } else if (widget.dealSummary != null) {
        _populateFormSummary(widget.dealSummary!);

      }
    } else {
        _isFetchingDetails = false;
    }


    await Future.wait([
        _fetchDropdownData(),
        if (_isEditMode && widget.deal == null) _fetchDealDetails(),
    ]);

    if (mounted) {
        setState(() {
            _isFetchingDetails = false;
        });
    }
  }

  void _populateFormSummary(DealModel summary) {
      _dealName.text = summary.title;
      _amount.text = summary.amount.replaceAll(',', '');
      _closingDate = summary.closingDate;
      // We don't have IDs in summary, so dropdowns will be empty until details fetch finishes
  }

  Future<void> _fetchDealDetails() async {
    try {
        final String uuid = widget.dealUuid ?? widget.dealSummary?.uuid ?? '';
        final int id = widget.dealId ?? widget.dealSummary?.id ?? 0;

        if (uuid.isEmpty || id == 0) return;

        final response = await WebFunctions().dealDetails(
            context: context,
            dealUuid: uuid,
            dealId: id,
        );
        if (mounted && response.result && response.response != null) {
            final detailsResponse = DealDetailsResponse.fromJson(response.response!);
            setState(() {
                _fetchedDeal = detailsResponse.deal;
            });
            if (_fetchedDeal != null) {
                _populateFormData(_fetchedDeal!);
            }
        }
    } catch (e) {
        debugPrint("Error fetching deal details for edit: $e");
    }
  }

  void _populateFormData(DealDetailsModel deal) {
    _dealName.text = deal.title;
    _amount.text = deal.amount.replaceAll(',', '');
    _description.text = deal.description ?? ''; 
    
    setState(() {
        _companyId = deal.companyId != 0 ? deal.companyId : null;
        _contactId = deal.clientId != 0 ? deal.clientId : null;
        _stageId = deal.accountStageId != 0 ? deal.accountStageId : null;
        
        _closingDate = deal.closingDate;
        _devCompletionDate = deal.customField153;
    });
  }

  Future<void> _fetchDropdownData() async {
    try {
      final companiesResponse = await WebFunctions().companies(
        context: context, 
        status: 'active', 
        page: 1
      );
      final contactsResponse = await WebFunctions().contacts(
        context: context, 
        status: 'active', 
        page: 1
      );

      if (mounted) {
        setState(() {
          if (companiesResponse.result) {
            _companies = List<Map<String, dynamic>>.from(
              companiesResponse.response?['data']?['company'] ?? []
            );
          }
          if (contactsResponse.result) {
            _contacts = List<Map<String, dynamic>>.from(
              contactsResponse.response?['data']?['clients'] ?? []
            );
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching dropdown data: $e");
    }
  }

  Future<void> _submit() async {
    if (_dealName.text.isEmpty || 
        _amount.text.isEmpty || 
        _companyId == null || 
        _contactId == null || 
        _stageId == null ||
        _closingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      ApiResponse response;
      
      if (_isEditMode) {

        final String uuid = _currentDeal?.uuid ?? widget.dealUuid ?? widget.dealSummary?.uuid ?? '';
        final int id = _currentDeal?.id ?? widget.dealId ?? widget.dealSummary?.id ?? 0;

        response = await WebFunctions().updateDeal(
          context: context,
          dealUuid: uuid,
          dealId: id,
          title: _dealName.text,
          companyId: _companyId!,
          clientId: _contactId!,
          accountStageId: _stageId!,
          amount: double.tryParse(_amount.text) ?? 0.0,
          closingDate: _closingDate!,
          description: _description.text,
          customField153: _devCompletionDate,
        );
      } else {
        response = await WebFunctions().storeDeal(
          context: context,
          title: _dealName.text,
          companyId: _companyId!,
          clientId: _contactId!,
          accountStageId: _stageId!,
          amount: double.tryParse(_amount.text) ?? 0.0,
          closingDate: _closingDate!,
          description: _description.text,
          customField153: _devCompletionDate,
        );
      }

      if (response.result) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isEditMode ? "Deal updated successfully" : "Deal created successfully")),
          );
          Navigator.pop(context, true); // Return true to trigger refresh
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.error)),
          );
        }
      }
    } catch (e) {
      debugPrint("Error submitting deal: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          /// APP BAR
          CustomAppBar(
            title: _isEditMode ? 'Edit Deal' : 'Create Deal',
            showBack: true,
          ),
          
          if (_isFetchingDetails)
            const LinearProgressIndicator(minHeight: 2, color: Color(0xFF2A7DE1)),

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
                    value: _companyId,
                    items: _companies,
                    nameKey: 'name', 
                    idKey: 'id', 
                    onChanged: (v) => setState(() => _companyId = v),
                  ),

                  _dropdown(
                    hint: 'Contact Name',
                    value: _contactId,
                    items: _contacts,
                    nameKey: 'client_name',
                    idKey: 'id', 
                    onChanged: (v) => setState(() => _contactId = v),
                  ),

                  _dropdown(
                    hint: 'Stage',
                    value: _stageId,
                    items: _stages,
                    nameKey: 'name',
                    idKey: 'id',
                    onChanged: (v) => setState(() => _stageId = v),
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
                        initialDate: _closingDate != null 
                            ? DateFormat('MM/dd/yyyy').parse(_closingDate!) 
                            : DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final String month = date.month.toString().padLeft(2, '0');
                        final String day = date.day.toString().padLeft(2, '0');
                        setState(() {
                          _closingDate = "$month/$day/${date.year}";
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
                        initialDate: _devCompletionDate != null 
                            ? DateFormat('MM/dd/yyyy').parse(_devCompletionDate!) 
                            : DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final String month = date.month.toString().padLeft(2, '0');
                        final String day = date.day.toString().padLeft(2, '0');
                        setState(() {
                          _devCompletionDate = "$month/$day/${date.year}";
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
            onPressed: _isLoading ? null : _submit,
            child: _isLoading 
              ? const SizedBox(
                  height: 20, 
                  width: 20, 
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                ) 
              : Text(
                  _isEditMode ? 'Update Deal' : 'Create Deal',
                  style: const TextStyle(
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
    required int? value,
    required List<Map<String, dynamic>> items,
    required String nameKey,
    required String idKey,
    required ValueChanged<int?> onChanged,
  }) {
    
    final uniqueItems = <int>{};
    final distinctItems = items.where((item) => uniqueItems.add(item[idKey])).toList();


    final bool valueExists = value == null || distinctItems.any((element) => element[idKey] == value);
    final int? safeValue = valueExists ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<int>(
        value: safeValue,
        hint: Text(hint),
        items: distinctItems.map((e) {
          return DropdownMenuItem<int>(
            value: e[idKey] as int,
            child: Text(e[nameKey]?.toString() ?? 'N/A'),
          );
        }).toList(),
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

