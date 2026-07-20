import 'package:bnan_app/features/chats/data/models/chat_room_details_model.dart';

class ChatRoomResponseModel {
  final bool success;
  final ChatRoomDetailsModel room;

  const ChatRoomResponseModel({
    required this.success,
    required this.room,
  });

  factory ChatRoomResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomResponseModel(
      success: json['success'] == true,
      room: ChatRoomDetailsModel.fromJson(
        Map<String, dynamic>.from(
          json['data'] as Map? ?? {},
        ),
      ),
    );
  }
}