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

  String get _type => mimeType.toLowerCase().trim();
  String get _extension => fileName.toLowerCase().split('.').last;

  bool get isImage =>
      _type.startsWith('image/') ||
      const {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'}.contains(_extension);

  bool get isVideo =>
      _type.startsWith('video/') ||
      const {'mp4', 'mov', 'webm', 'mkv'}.contains(_extension);

  bool get isAudio =>
      _type.startsWith('audio/') ||
      const {'m4a', 'mp3', 'wav', 'aac', 'ogg'}.contains(_extension);

  bool get isPdf => _type == 'application/pdf' || _extension == 'pdf';

  bool get isFile => !isImage && !isVideo && !isAudio;
}
