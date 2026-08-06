class ChatAttachmentModel {
  final String id;
  final String fileName;
  final String fileUrl;
  final String mimeType;
  final int size;

  const ChatAttachmentModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.mimeType,
    required this.size,
  });

  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) {
    return ChatAttachmentModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? '',
      size: _parseSize(json['size']),
    );
  }

  static int _parseSize(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool get isImage => mimeType.startsWith('image/');

  bool get isVideo => mimeType.startsWith('video/');

  bool get isAudio => mimeType.startsWith('audio/');

  bool get isPdf => mimeType == 'application/pdf';

  bool get isFile => !isImage && !isVideo && !isAudio;
}
