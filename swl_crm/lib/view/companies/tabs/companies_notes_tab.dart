import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/note_model.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';
import 'package:intl/intl.dart';

class CompaniesNotesTab extends StatefulWidget {
  final CompanyDetailsModel? company;
  const CompaniesNotesTab({super.key, this.company});

  @override
  State<CompaniesNotesTab> createState() => _CompaniesNotesTabState();
}

class _CompaniesNotesTabState extends State<CompaniesNotesTab> {
  final WebFunctions _api = WebFunctions();
  bool _isLoading = true;
  List<NoteModel> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    if (widget.company == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);
    final response = await _api.getCompanyNotes(
      context: context,
      companyUuid: widget.company?.uuid ?? '',
      companyId: widget.company?.id ?? 0,
    );

    if (mounted) {
      if (response.result) {
        var rawData = response.response!['data'];
        
        // Check for 'notes' key first (matches user logs)
        if (rawData is Map && rawData.containsKey('notes')) {
          final notesData = rawData['notes'];
          if (notesData is List) {
            _notes = notesData.map((e) => NoteModel.fromJson(e)).toList();
          }
        } 

        else {
          if (rawData is Map && rawData.containsKey('data')) {
            rawData = rawData['data'];
          }
          
          if (rawData is List) {
            _notes = rawData.map((e) => NoteModel.fromJson(e)).toList();
          } else {
            _notes = [];
          }
        }
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_notes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No notes available',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _notes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final note = _notes[index];
        return _NoteItem(note: note);
      },
    );
  }
}

class _NoteItem extends StatelessWidget {
  final NoteModel note;

  const _NoteItem({required this.note});

  @override
  Widget build(BuildContext context) {
    // Format date attempt
    String formattedDate = note.createdAt;
    try {
      final date = DateTime.parse(note.createdAt);
      formattedDate = DateFormat('MMM dd, yyyy h:mm a').format(date);
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE8F1FD),
                backgroundImage: note.userImage.isNotEmpty ? NetworkImage(note.userImage) : null,
                child: note.userImage.isEmpty
                    ? Text(
                        note.userName.isNotEmpty ? note.userName.substring(0, 1).toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Color(0xFF2A7DE1),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.userName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.edit, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    child: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            note.note,
            style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
          ),
          if (note.attachments.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...note.attachments.map((file) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image_outlined, color: Color(0xFF2A7DE1), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.fileName,
                          style: const TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          file.fileSize, 
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    child: const Icon(Icons.remove_red_eye_outlined, size: 20, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    child: const Icon(Icons.download, size: 20, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    child: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}
