import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';

class ChatRoomsResponseModel {
  final bool success;
  final int results;
  final List<ChatRoomSummaryModel> rooms;

  const ChatRoomsResponseModel({
    required this.success,
    required this.results,
    required this.rooms,
  });

  factory ChatRoomsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];

    return ChatRoomsResponseModel(
      success: json['success'] == true,
      results: json['results'] as int? ?? data.length,
      rooms: data
          .whereType<Map>()
          .map(
            (room) =>
                ChatRoomSummaryModel.fromJson(Map<String, dynamic>.from(room)),
          )
          .toList(),
    );
  }
}
