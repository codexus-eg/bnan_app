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

  static const List<ChatMessageModel> placeholders = [
    placeholder,
    placeholder,
    placeholder,
    placeholder,
    placeholder,
    placeholder,
  ];

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'];
    final attachmentsJson = json['attachments'] as List<dynamic>? ?? [];

    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      roomId: json['room']?.toString() ?? '',
      sender: senderJson is Map
          ? ChatSenderModel.fromJson(Map<String, dynamic>.from(senderJson))
          : const ChatSenderModel(id: '', fullName: '', role: ''),
      text: json['text']?.toString() ?? '',
      attachments: attachmentsJson
          .whereType<Map>()
          .map(
            (attachment) => ChatAttachmentModel.fromJson(
              Map<String, dynamic>.from(attachment),
            ),
          )
          .toList(),
      messageType: json['messageType']?.toString() ?? 'text',
      deletedForEveryone: json['deletedForEveryone'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      editedAt: DateTime.tryParse(json['editedAt']?.toString() ?? ''),
    );
  }
}
