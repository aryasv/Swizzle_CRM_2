import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class CompaniesNotesTab extends StatefulWidget {
  const CompaniesNotesTab({super.key});

  @override
  State<CompaniesNotesTab> createState() => _CompaniesNotesTabState();
}

class _CompaniesNotesTabState extends State<CompaniesNotesTab> {

  final List<Map<String, dynamic>> _staticNotes = [
    {
      'id': 1,
      'userName': 'John',
      'userInitials': 'SM',
      'date': 'Feb 10, 2026 09:42 PM',
      'note': 'Test',
      'attachments': [],
    },
    {
      'id': 2,
      'userName': 'Ani',
      'userInitials': 'AV',
      'date': 'Feb 05, 2026 11:55 PM',
      'note': 'Note',
      'attachments': [],
    },
    {
      'id': 3,
      'userName': 'Vijay',
      'userInitials': 'AV',
      'date': 'Feb 05, 2026 10:00 PM',
      'note': 'Test Note',
      'attachments': [
        {
          'name': 'Frame 1 3.png',
          'size': '357.10 KB',
          'type': 'image',
        },
        {
          'name': 'image (14) 1 1.png',
          'size': '115.50 KB',
          'type': 'image',
        }
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _staticNotes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final note = _staticNotes[index];
        return _NoteItem(note: note);
      },
    );
  }
}

class _NoteItem extends StatelessWidget {
  final Map<String, dynamic> note;

  const _NoteItem({required this.note});

  @override
  Widget build(BuildContext context) {
    var attachments = note['attachments'] as List;

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
                child: Text(
                  note['userInitials'],
                  style: const TextStyle(
                    color: Color(0xFF2A7DE1),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note['userName'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note['date'],
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
            note['note'],
            style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
          ),
          if (attachments.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...attachments.map((file) => Container(
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
                          file['name'],
                          style: const TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          file['size'], 
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
