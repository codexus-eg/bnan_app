import 'package:bnan_app/features/chats/data/models/chat_room_details_model.dart';

class ChatRoomResponseModel {
  final bool success;
  final bool created;
  final ChatRoomDetailsModel room;

  const ChatRoomResponseModel({
    required this.success,
    required this.room,
    this.created = false,
  });

  factory ChatRoomResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    return ChatRoomResponseModel(
      success: json['success'] == true,
      created: json['created'] == true || data['created'] == true,
      room: ChatRoomDetailsModel.fromJson(
        Map<String, dynamic>.from(data['room'] as Map? ?? data),
      ),
    );
  }
}
