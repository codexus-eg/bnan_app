import 'package:bnan_app/features/chats/presentation/manager/chat_room_metadata/chat_room_metadata_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/chat_room_metadata/chat_room_metadata_state.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:flutter_test/flutter_test.dart';
import 'chat_room_metadata_test_support.dart';

void main() {
  final origins = <String, ChatRouteArgs>{
    'subject request': const ChatRouteArgs(classroomId: 'classroom-id'),
    'notification fallback': const ChatRouteArgs(classroomName: 'Math'),
    'direct route': const ChatRouteArgs(),
  };
  for (final origin in origins.entries) {
    test('${origin.key} resolves metadata from room details', () async {
      final repo = MetadataRepo();
      final cubit = ChatRoomMetadataCubit(
        repo,
        ChatRoomMetadataState.fromArgs(origin.value),
      );
      await cubit.load('room-id');
      expect(repo.calls, 1);
      expect(cubit.state.accessScope, 'private');
      expect(cubit.state.classroomSubjectId, 'subject-id');
      expect(cubit.state.canRequestTeacherWithdrawal, isTrue);
      await cubit.close();
    });
  }

  test('complete Gulf metadata stays unchanged', () async {
    final repo = MetadataRepo();
    final cubit = ChatRoomMetadataCubit(repo, completeMetadata);
    await cubit.load('room-id');
    expect(repo.calls, 0);
    expect(cubit.state, same(completeMetadata));
    await cubit.close();
  });
}

const completeMetadata = ChatRoomMetadataState(
  roomType: 'classroom',
  classroomId: 'classroom-id',
  accessScope: 'private',
  classroomSubjectId: 'subject-id',
  canRequestTeacherWithdrawal: true,
  classroomSubjectAmbiguous: false,
);
