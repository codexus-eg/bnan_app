class MessageDocumentItem {
  const MessageDocumentItem({
    required this.id,
    required this.messageId,
    required this.url,
    required this.fileName,
    required this.messageTitle,
    required this.senderName,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.isExternalLink,
  });

  final String id;
  final String messageId;
  final String url;
  final String fileName;
  final String messageTitle;
  final String senderName;
  final String mimeType;
  final int size;
  final DateTime? createdAt;
  final bool isExternalLink;
}
