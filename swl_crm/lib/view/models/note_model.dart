class NoteModel {
  final int id;
  final String uuid;
  final String note;
  final int createdBy;
  final String createdAt;
  final String updatedAt;
  final String userName;
  final String userImage;
  final List<AttachmentModel> attachments;

  NoteModel({
    required this.id,
    required this.uuid,
    required this.note,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.userImage,
    required this.attachments,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? 0,
      uuid: json['note_uuid'] ?? '',
      note: json['note'] ?? '',
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      attachments: (json['documents'] as List<dynamic>?)
              ?.map((e) => AttachmentModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AttachmentModel {
  final int id;
  final String fileName;
  final String fileUrl;
  final String fileSize;
  final String fileType;

  AttachmentModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] ?? 0,
      fileName: json['file_name'] ?? '',
      fileUrl: json['image_path'] ?? '',
      fileSize: json['file_size'] ?? '',
      fileType: json['file_type'] ?? '',
    );
  }
}
