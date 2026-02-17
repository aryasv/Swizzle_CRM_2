import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/models/company_details_note_model.dart';
import 'package:swl_crm/view/models/companies_details_model.dart';
import 'package:intl/intl.dart';

import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';


class CompaniesNotesTab extends StatefulWidget {
  final CompanyDetailsModel? company;
  const CompaniesNotesTab({super.key, this.company});

  @override
  State<CompaniesNotesTab> createState() => _CompaniesNotesTabState();
}

class _CompaniesNotesTabState extends State<CompaniesNotesTab> {
  final WebFunctions _api = WebFunctions();
  bool _isLoading = true;
  List<CompanyDetailsNoteModel> _notes = [];

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
            _notes = notesData.map((e) => CompanyDetailsNoteModel.fromJson(e)).toList();
          }
        } 

        else {
          if (rawData is Map && rawData.containsKey('data')) {
            rawData = rawData['data'];
          }
          
          
          if (rawData is List) {
            _notes = rawData.map((e) => CompanyDetailsNoteModel.fromJson(e)).toList();
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
        return _NoteItem(
          note: note,
          onDelete: () => _confirmDelete(note),
        );
      },
    );
  }

  Future<void> _confirmDelete(CompanyDetailsNoteModel note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteNote(note);
    }
  }

  Future<void> _deleteNote(CompanyDetailsNoteModel note) async {

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleting note...')),
    );

    final response = await _api.deleteCompanyNote(
      context: context,
      companyUuid: widget.company?.uuid ?? '',
      companyId: widget.company?.id ?? 0,
      noteUuid: note.uuid,
      noteId: note.id,
    );

    if (mounted) {
      if (response.result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted successfully')),
        );
        _loadNotes();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error)),
        );
      }
    }
  }
}

class _NoteItem extends StatelessWidget {
  final CompanyDetailsNoteModel note;
  final VoidCallback? onDelete;

  const _NoteItem({required this.note, this.onDelete});

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
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.transparent,
                      child: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                    ),
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppBar(
                                title: Text(file.fileName),
                                leading: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                automaticallyImplyLeading: false,
                              ),
                              Flexible(
                                child: InteractiveViewer(
                                  child: Image.network(
                                    file.fileUrl,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                          SizedBox(height: 10),
                                          Text('Unable to load image preview'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.remove_red_eye_outlined, size: 20, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading image...')),
                        );

                       
                        bool hasAccess = await Gal.hasAccess();
                        if (!hasAccess) {
                          await Gal.requestAccess();
                        }

                        var response = await http.get(Uri.parse(file.fileUrl));
                        
                        if (response.statusCode == 200) {

                          await Gal.putImageBytes(
                            Uint8List.fromList(response.bodyBytes),
                            name: file.fileName,
                          );
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Image saved to gallery successfully')),
                            );
                          }
                        } else {
                           if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to download image')),
                            );
                          }
                        }
                      } catch (e) {
                         if (context.mounted) {
                            // Gal specific error handling could be added here
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error downloading image: $e')),
                            );
                          }
                      }
                    },
                    child: const Icon(Icons.download, size: 20, color: Colors.grey),
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
