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
  Future<Either<Failure, ChatRoomResponseModel>> createSupportRoom({
    required String userId,
  }) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.createSupportRoom,
        data: {'userId': userId},
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
  Future<Either<Failure, ChatMessageResponseModel>> sendMessage({
    required String roomId,
    String? text,
    List<String>? attachmentPaths,
  }) async {
    try {
      final trimmedText = text?.trim();

      final attachments = <MultipartFile>[];

      for (final path in attachmentPaths ?? <String>[]) {
        attachments.add(
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        );
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
}
