import 'package:bnan_app/features/chats/data/models/chat_participant_model.dart';

class ChatRoomDetailsModel {
  final String id;
  final String type;
  final List<ChatParticipantModel> participants;
  final bool isActive;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const ChatRoomDetailsModel({
    required this.id,
    required this.type,
    required this.participants,
    required this.isActive,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatRoomDetailsModel.fromJson(Map<String, dynamic> json) {
    final participantsJson = json['participants'] as List<dynamic>? ?? [];

    return ChatRoomDetailsModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      participants: participantsJson
          .whereType<Map>()
          .map(
            (participant) => ChatParticipantModel.fromJson(
              Map<String, dynamic>.from(participant),
            ),
          )
          .toList(),
      isActive: json['isActive'] == true,
      lastMessage: json['lastMessage']?.toString(),
      lastMessageAt: DateTime.tryParse(
        json['lastMessageAt']?.toString() ?? '',
      ),
    );
  }
}