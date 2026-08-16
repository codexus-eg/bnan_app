import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  Future<Either<Failure, ChatRoomResponseModel>> createSupportRoom();

  Future<Either<Failure, ChatRoomResponseModel>> openSupervisorStudentRoom({
    required String studentId,
  });

  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms();

  Future<Either<Failure, ChatRoomsResponseModel>> getAdminChatRooms({
    String? search,
  });

  Future<Either<Failure, ChatRoomResponseModel>> getChatRoom({
    required String roomId,
  });

  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({
    required String roomId,
  });

  Future<Either<Failure, ChatMessageResponseModel>> sendMessage({
    required String roomId,
    String? text,
    List<String>? attachmentPaths,
  });

  Future<Either<Failure, ChatMessageResponseModel>> editMessage({
    required String messageId,
    required String text,
  });

  Future<Either<Failure, void>> deleteMessage({required String messageId});

  Future<Either<Failure, void>> deleteMessages({
    required String roomId,
    required List<String> messageIds,
  });
}
