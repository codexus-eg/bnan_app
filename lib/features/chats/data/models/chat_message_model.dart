import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';

class ChatMessageModel {
  final String id;
  final String roomId;
  final ChatSenderModel sender;
  final String text;
  final List<ChatAttachmentModel> attachments;
  final String messageType;
  final bool deletedForEveryone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? editedAt;

  const ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.sender,
    required this.text,
    required this.attachments,
    required this.messageType,
    required this.deletedForEveryone,
    this.createdAt,
    this.updatedAt,
    this.editedAt,
  });

  static const ChatMessageModel placeholder = ChatMessageModel(
    id: 'placeholder-id',
    roomId: 'placeholder-room-id',
    sender: ChatSenderModel(
      id: 'placeholder-sender-id',
      fullName: 'اسم المستخدم',
      role: 'student',
    ),
    text: 'هذه رسالة تجريبية لعرض حالة التحميل',
    attachments: [],
    messageType: 'text',
    deletedForEveryone: false,
  );

  static List<ChatMessageModel> get placeholders => List.generate(
    6,
    (i) => ChatMessageModel(
      id: 'placeholder-id-$i',
      roomId: 'placeholder-room-id',
      sender: const ChatSenderModel(
        id: 'placeholder-sender-id',
        fullName: 'اسم المستخدم',
        role: 'student',
      ),
      text: 'هذه رسالة تجريبية لعرض حالة التحميل',
      attachments: const [],
      messageType: 'text',
      deletedForEveryone: false,
    ),
  );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'];

    return ChatMessageModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      roomId: _parseRoomId(json['room'] ?? json['roomId']),
      sender: senderJson is Map
          ? ChatSenderModel.fromJson(Map<String, dynamic>.from(senderJson))
          : const ChatSenderModel(id: '', fullName: '', role: ''),
      text: json['text']?.toString() ?? '',
      attachments: _parseAttachments(json),
      messageType: json['messageType']?.toString() ?? 'text',
      deletedForEveryone: json['deletedForEveryone'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      editedAt: DateTime.tryParse(json['editedAt']?.toString() ?? ''),
    );
  }

  static List<ChatAttachmentModel> _parseAttachments(
    Map<String, dynamic> json,
  ) {
    final attachmentsJson = json['attachments'] as List<dynamic>? ?? [];
    final attachments = attachmentsJson
        .whereType<Map>()
        .map(
          (item) =>
              ChatAttachmentModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
    final recording = json['recording'];
    final recordingJson = recording is Map
        ? Map<String, dynamic>.from(recording)
        : const <String, dynamic>{};
    final localUrl = recordingJson['localUrl']?.toString().trim() ?? '';
    final recordLink = json['messageType'] == 'session_record'
        ? json['recordLink']?.toString().trim() ?? ''
        : '';
    final fileUrl = localUrl.isNotEmpty ? localUrl : recordLink;

    if (fileUrl.isEmpty ||
        attachments.any((attachment) => attachment.fileUrl == fileUrl)) {
      return attachments;
    }

    final uri = Uri.tryParse(fileUrl);
    final fileName = recordingJson['fileName']?.toString().trim();
    attachments.add(
      ChatAttachmentModel(
        id: recordingJson['id']?.toString() ?? '',
        fileName: fileName?.isNotEmpty == true
            ? fileName!
            : uri?.pathSegments.lastOrNull ?? 'recording.mp4',
        fileUrl: fileUrl,
        mimeType: recordingJson['mimeType']?.toString() ?? 'video/mp4',
        size: int.tryParse(recordingJson['size']?.toString() ?? '') ?? 0,
      ),
    );
    return attachments;
  }

  static String _parseRoomId(dynamic room) {
    if (room is Map) {
      return room['id']?.toString() ?? room['_id']?.toString() ?? '';
    }

    return room?.toString() ?? '';
  }

  bool isMine(String currentUserId) {
    final userId = currentUserId.trim();
    return userId.isNotEmpty && sender.id.trim() == userId;
  }

  bool get isNonDisplayableSessionEvent =>
      messageType == 'session_report' ||
      messageType == 'session_summary' ||
      messageType == 'session_record';

  ChatMessageModel markDeleted() => ChatMessageModel(
    id: id,
    roomId: roomId,
    sender: sender,
    text: '',
    attachments: const [],
    messageType: messageType,
    deletedForEveryone: true,
    createdAt: createdAt,
    updatedAt: updatedAt,
    editedAt: editedAt,
  );
}
