import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('payload roomName reaches chat route arguments', () async {
    final destination = await _service().resolveDestination(
      _notification(params: {'roomId': '1', 'roomName': 'Mathematics'}),
    );
    expect(destination.path, '/chat/1');
    expect((destination.extra as ChatRouteArgs).classroomName, 'Mathematics');
  });

  test('cached room reuses the chat list displayName', () async {
    final cache = ChatRoomsCache(SessionManager.instance)..replace([_room]);
    final destination = await _service(
      cache: cache,
    ).resolveDestination(_notification(params: {'roomId': '1'}));
    expect(
      (destination.extra as ChatRouteArgs).classroomName,
      _room.displayName,
    );
  });

  test('missing cache loads current rooms repository', () async {
    final destination = await _service(
      repo: _Repo(),
    ).resolveDestination(_notification(params: {'roomId': '1'}));
    expect(
      (destination.extra as ChatRouteArgs).classroomName,
      _room.displayName,
    );
  });

  test('repository failure still opens room with safe fallback', () async {
    final destination = await _service(
      repo: _FailingRepo(),
    ).resolveDestination(_notification(params: {'roomId': 'missing'}));
    final args = destination.extra as ChatRouteArgs;
    expect(destination.path, '/chat/missing');
    expect(args.classroomName, isNull);
  });
}

NotificationNavigationService _service({
  ChatRoomsCache? cache,
  ChatRepo? repo,
}) => NotificationNavigationService(
  SessionManager.instance,
  chatRepo: repo,
  roomsCache: cache,
);
AppNotification _notification({required Object params}) =>
    AppNotification.fromJson({
      'id': 'n1',
      'key': 'NEW_MESSAGE',
      'params': params,
    });
const _room = ChatRoomSummaryModel(
  id: '1',
  type: 'classroom',
  displayName: 'Mathematics',
  subtitle: '',
  classroomId: 'c1',
);

class _Repo extends Fake implements ChatRepo {
  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async =>
      const Right(
        ChatRoomsResponseModel(success: true, results: 1, rooms: [_room]),
      );
}

class _FailingRepo extends Fake implements ChatRepo {
  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async =>
      Left(Failure(message: 'offline'));
}
