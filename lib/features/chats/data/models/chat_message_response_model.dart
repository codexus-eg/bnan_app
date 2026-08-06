import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';

class ChatMessageResponseModel {
  final bool success;
  final ChatMessageModel message;

  const ChatMessageResponseModel({
    required this.success,
    required this.message,
  });

  factory ChatMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponseModel(
      success: json['success'] == true,
      message: ChatMessageModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map? ?? {}),
      ),
    );
  }
}
