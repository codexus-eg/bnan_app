import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';

class ChatMessagesResponseModel {
  final bool success;
  final int results;
  final List<ChatMessageModel> messages;

  const ChatMessagesResponseModel({
    required this.success,
    required this.results,
    required this.messages,
  });

  factory ChatMessagesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as List<dynamic>? ?? [];

    return ChatMessagesResponseModel(
      success: json['success'] == true,
      results: json['results'] as int? ?? data.length,
      messages: data
          .whereType<Map>()
          .map(
            (message) => ChatMessageModel.fromJson(
              Map<String, dynamic>.from(message),
            ),
          )
          .toList(),
    );
  }
}