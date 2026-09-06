import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ChatRepoImpl implements ChatRepo {
  const ChatRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, ChatRoomResponseModel>> openSupervisorStudentRoom({
    required String studentId,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.supervisorStudentRoom,
        data: {'studentId': studentId.trim()},
        isProtected: true,
      );
      return Right(ChatRoomResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(
        Failure(
          message: error.message,
          responseReceived: error.responseReceived,
          statusCode: error.statusCode,
          code: error.code,
        ),
      );
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ChatRoomResponseModel>> createSupportRoom() async {
    try {
      final response = await apiConsumer.post(
        EndPoints.createSupportRoom,
        data: const <String, dynamic>{},
        isProtected: true,
      );

      return Right(ChatRoomResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getMyChatRooms,
        isProtected: true,
      );

      return Right(ChatRoomsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getAdminChatRooms({
    String? search,
  }) async {
    try {
      final query = search?.trim();
      final response = await apiConsumer.get(
        EndPoints.adminChatRooms,
        queryParameter: query?.isNotEmpty == true ? {'search': query} : null,
        isProtected: true,
      );

      return Right(ChatRoomsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ChatRoomResponseModel>> getChatRoom({
    required String roomId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getChatRoom(roomId),
        isProtected: true,
      );

      return Right(ChatRoomResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({
    required String roomId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getRoomMessages(roomId),
        isProtected: true,
      );

      return Right(ChatMessagesResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, void>> markRoomAsRead({required String roomId}) async {
    try {
      await apiConsumer.patch(
        EndPoints.markRoomAsRead(roomId),
        isProtected: true,
      );
      return const Right(null);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ChatMessageResponseModel>> sendMessage({
    required String roomId,
    String? text,
    List<String>? attachmentPaths,
  }) async {
    try {
      final trimmedText = text?.trim();

      final attachments = <MultipartFile>[];

      for (final path in attachmentPaths ?? <String>[]) {
        attachments.add(await MultipartFile.fromFile(path));
      }

      final formData = FormData.fromMap({
        'roomId': roomId,
        if (trimmedText != null && trimmedText.isNotEmpty) 'text': trimmedText,
        if (attachments.isNotEmpty) 'attachments': attachments,
      });

      final response = await apiConsumer.post(
        EndPoints.sendMessage,
        data: formData,
        isProtected: true,
      );

      return Right(ChatMessageResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ChatMessageResponseModel>> editMessage({
    required String messageId,
    required String text,
  }) async {
    try {
      final response = await apiConsumer.patch(
        EndPoints.editMessage(messageId),
        data: {'text': text.trim()},
        isProtected: true,
      );

      return Right(ChatMessageResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage({
    required String messageId,
  }) async {
    try {
      await apiConsumer.delete(
        EndPoints.deleteMessage(messageId),
        isProtected: true,
      );

      return const Right(null);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessages({
    required String roomId,
    required List<String> messageIds,
  }) async {
    try {
      await apiConsumer.delete(
        EndPoints.deleteRoomMessages(roomId),
        data: {'messageIds': messageIds},
        isProtected: true,
      );
      return const Right(null);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}
