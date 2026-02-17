import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';
import 'package:swl_crm/view/models/companies_model.dart';
import 'package:swl_crm/view/companies/tabs/companies_notes_tab.dart';
import 'package:swl_crm/view/companies/tabs/companies_deals_tab.dart';

class CompaniesDetailsPage extends StatefulWidget {
  final int companyId;
  final String companyUuid;

  const CompaniesDetailsPage({
    super.key,
    required this.companyId,
    required this.companyUuid,
  });

  @override
  State<CompaniesDetailsPage> createState() => _CompaniesDetailsPageState();
}


class _CompaniesDetailsPageState extends State<CompaniesDetailsPage> {
  CompanyDetailsModel? company;
  bool isLoading = true;
  String _selectedTab = 'Basic Info';
  Key _notesTabKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    final api = WebFunctions();

    final response = await api.companyDetails(
      context: context,
      companyUuid: widget.companyUuid,
      companyId: widget.companyId,
    );


    if (!mounted) return;

    if (response.result) {
      company = CompanyDetailsModel.fromJson(
        response.response!['data'],
      );
      if (company!.menus.isNotEmpty) {
        _selectedTab = company!.menus.first.label;
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: _selectedTab == 'Notes'
          ? FloatingActionButton.extended(
              onPressed: _showAddNoteBottomSheet,
              backgroundColor: const Color(0xFF0D70E3), // Primary blue
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Note',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          : null,
      body: Column(
        children: [
          CustomAppBar(
            title: 'Company Details',
            showBack: true,
            rightAction1: SizedBox(
              width: 40,
              height: 40,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert, size: 22),
                offset: const Offset(0, 40),
                onSelected: (v) async {
                  if (v == 'edit' && company != null) {
                    final companyModel = CompanyModel(
                      id: company!.id,
                      uuid: company!.uuid,
                      name: company!.name,
                      phone: company!.phone,
                      website: company!.website,
                      email: company!.email,
                      address: company!.address,
                      city: company!.city,
                      zip: company!.zip,
                      state: '',
                      country: '',
                      isDeleted: false,
                    );

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompaniesFormPage(company: companyModel),
                      ),
                    );

                    if (result == true) {
                      _loadCompany();
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
                : company == null
                ? const Center(child: Text('Failed to load company'))
                : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 72),
              child: Column(
                children: [
                  _companyHeader(company!),
                  const SizedBox(height: 16),

                  _tabBar(),
                  const SizedBox(height: 16),

                  if (_selectedTab == 'Basic Info') ...[
                    _section(
                      title: 'Company Information',
                      icon: Icons.info_outline,
                      children: [
                        _infoRow(Icons.business, 'Company Name', company!.name),
                        _infoRow(Icons.phone, 'Phone', company!.phone, isLink: true),
                        _infoRow(Icons.language, 'Website', company!.website, isLink: true),
                        _infoRow(Icons.email, 'Email', company!.email, isLink: true),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _section(
                      title: 'Address Information',
                      icon: Icons.location_on_outlined,
                      children: [
                        _infoRow(Icons.location_city, 'Address', company!.address),
                        _infoRow(Icons.location_city, 'City', company!.city),
                        _infoRow(Icons.pin_drop, 'Zip', company!.zip),
                      ],
                    ),
                  ] else if (_selectedTab == 'Notes') ...[
                     CompaniesNotesTab(key: _notesTabKey, company: company),
                  ] else if (_selectedTab == 'Deals') ...[
                     CompaniesDealsTab(company: company),
                  ] else ...[
                     Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      decoration: _cardDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No ${_selectedTab.toLowerCase()} available',
                            style: TextStyle(color: Colors.grey[500], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  // TAB BAR
  Widget _tabBar() {
    if (company == null || company!.menus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: _cardDecoration(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: company!.menus.map((menu) {
            return _buildTabItem(menu.label);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabItem(String label) {
    bool isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: isSelected
              ? const Border(bottom: BorderSide(color: Color(0xFF2A7DE1), width: 2))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF2A7DE1) : Colors.grey,
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _companyHeader(CompanyDetailsModel c) {
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
            child: const Icon(Icons.apartment, color: Color(0xFF2A7DE1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  c.website,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SECTION
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final leftWidth = constraints.maxWidth * 0.35;
          final rightWidth = constraints.maxWidth * 0.65;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF2A7DE1)),
              const SizedBox(width: 12),

              SizedBox(
                width: leftWidth - 30,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),

              SizedBox(
                width: rightWidth,
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
          );
        },
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

  void _showAddNoteBottomSheet() {
    final noteController = TextEditingController();
    bool isSaving = false;
    List<XFile> attachments = [];
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            
            Future<void> pickImage(ImageSource source) async {
              try {
                final XFile? image = await picker.pickImage(source: source);
                if (image != null) {
                  setModalState(() {
                    attachments.add(image);
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to pick image')),
                );
              }
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Note',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Note Input
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: noteController,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText: 'Enter your note here...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Attachments Label
                          const Text(
                            'Attachments',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),

                          // Selected Images List
                          if (attachments.isNotEmpty)
                            Container(
                              height: 100,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: attachments.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: FileImage(File(attachments[index].path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              attachments.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          
                          // Attachment Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => pickImage(ImageSource.gallery),
                                  icon: const Icon(Icons.image_outlined, color: Color(0xFF2A7DE1)),
                                  label: const Text('Gallery', style: TextStyle(color: Color(0xFF2A7DE1))),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF2A7DE1)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => pickImage(ImageSource.camera),
                                  icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF2A7DE1)),
                                  label: const Text('Camera', style: TextStyle(color: Color(0xFF2A7DE1))),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF2A7DE1)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Footer Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving 
                          ? null 
                          : () async {
                              final text = noteController.text.trim();
                              if (text.isEmpty && attachments.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter a note or add an attachment')),
                                );
                                return;
                              }

                              setModalState(() => isSaving = true);
                              
                              final api = WebFunctions();
                              final response = await api.addCompanyNote(
                                context: context,
                                companyUuid: widget.companyUuid,
                                companyId: widget.companyId,
                                note: text,
                                attachments: attachments,
                              );

                              if (mounted) {
                                setModalState(() => isSaving = false);
                                
                                if (response.result) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Note added successfully')),
                                  );
                                  // Trigger refresh of notes tab
                                  setState(() {
                                    _notesTabKey = UniqueKey();
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response.error)),
                                  );
                                }
                              }
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D70E3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Save Note',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
}
