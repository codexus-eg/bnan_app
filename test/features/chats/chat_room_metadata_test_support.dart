import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_details_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_response_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MetadataRepo extends Fake implements ChatRepo {
  int calls = 0;
  @override
  Future<Either<Failure, ChatRoomResponseModel>> getChatRoom({
    required String roomId,
  }) async {
    calls++;
    return const Right(ChatRoomResponseModel(success: true, room: details));
  }
}

const details = ChatRoomDetailsModel(
  id: 'room-id',
  type: 'classroom',
  classroomId: 'classroom-id',
  accessScope: 'private',
  classroomSubjectId: 'subject-id',
  canRequestTeacherWithdrawal: true,
  classroomSubjectAmbiguous: false,
  participants: [],
  isActive: true,
);
