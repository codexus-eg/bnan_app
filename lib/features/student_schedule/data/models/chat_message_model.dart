
import 'package:bnan_app/features/student_schedule/data/models/chat_sender_type.dart';

class ChatMessageModel {
  const ChatMessageModel({
    required this.message,
    required this.time,
    required this.senderType,
  });

  final String message;
  final String time;
  final ChatSenderType senderType;
}