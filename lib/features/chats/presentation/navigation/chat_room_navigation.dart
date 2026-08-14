import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';

abstract final class ChatRoomNavigation {
  static String? path(ChatRoomSummaryModel room) {
    final roomId = room.id.trim();
    return roomId.isEmpty ? null : Routes.chatPath(roomId);
  }

  static ChatRouteArgs arguments(
    ChatRoomSummaryModel room, {
    required String? currentUserRole,
    String? displayName,
  }) {
    return ChatRouteArgs(
      roomType: room.type,
      classroomId: room.classroomId,
      classroomName: displayName ?? room.displayName,
      currentUserRole: currentUserRole,
    );
  }
}
