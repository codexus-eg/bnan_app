import 'package:bnan_app/features/chats/data/models/chat_participant_model.dart';

class ChatRoomDetailsModel {
  final String id;
  final String type;
  final String? classroomId;
  final String? accessScope;
  final String? classroomSubjectId;
  final bool? canRequestTeacherWithdrawal;
  final bool? classroomSubjectAmbiguous;
  final List<ChatParticipantModel> participants;
  final bool isActive;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatRoomDetailsModel({
    required this.id,
    required this.type,
    this.classroomId,
    this.accessScope,
    this.classroomSubjectId,
    this.canRequestTeacherWithdrawal,
    this.classroomSubjectAmbiguous,
    required this.participants,
    required this.isActive,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory ChatRoomDetailsModel.fromJson(Map<String, dynamic> json) {
    final participantsJson = json['participants'] as List<dynamic>? ?? [];
    String? text(Object? value) {
      final result = value is String ? value.trim() : '';
      return result.isEmpty ? null : result;
    }

    final classroom = json['classroom'];
    final legacyClassroomId = classroom is Map
        ? text(classroom['id'] ?? classroom['_id'])
        : text(classroom);

    return ChatRoomDetailsModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      classroomId: text(json['classroomId']) ?? legacyClassroomId,
      accessScope: text(json['accessScope'])?.toLowerCase(),
      classroomSubjectId: text(json['classroomSubjectId']),
      canRequestTeacherWithdrawal: json['canRequestTeacherWithdrawal'] is bool
          ? json['canRequestTeacherWithdrawal'] as bool
          : null,
      classroomSubjectAmbiguous: json['classroomSubjectAmbiguous'] is bool
          ? json['classroomSubjectAmbiguous'] as bool
          : null,
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
      lastMessageAt: DateTime.tryParse(json['lastMessageAt']?.toString() ?? ''),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }
}
