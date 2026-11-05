import 'package:bnan_app/core/app_routes/routes.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
    await SessionManager.instance.saveSession(
      accessToken: 'token',
      refreshToken: '',
      userRole: 'student',
    );
  });

  const payloadNotification = {
    'id': 'notif-1',
    'key': 'STUDENT_ACCEPTED_IN_CLASSROOM',
    'navigation': {
      'screen': 'classroom_details',
      'target': 'classroom_details',
      'params': {
        'classroomId': '6adcc71f0f5958c8e31fd1db',
        'classroomSubjectId': '6adcc7200f5958c8e31fd1dc',
        'subjectId': '6a9b4af59fb900ca8a77798b',
      },
    },
  };

  const mathRoom = ChatRoomSummaryModel(
    id: '6adcc7218df6140845e66317',
    type: 'classroom',
    displayName: 'samar - الرياضيات',
    subtitle: 'فصل دراسي',
    classroomId: '6adcc71f0f5958c8e31fd1db',
    classroomSubjectId: '6adcc7200f5958c8e31fd1dc',
  );

  const scienceRoom = ChatRoomSummaryModel(
    id: 'room-science-id',
    type: 'classroom',
    displayName: 'samar - العلوم',
    subtitle: 'فصل دراسي',
    classroomId: '6adcc71f0f5958c8e31fd1db',
    classroomSubjectId: 'other-subject-id',
  );

  test('resolves exact room using classroomId and classroomSubjectId on cold start', () async {
    final service = NotificationNavigationService(
      SessionManager.instance,
      chatRepo: _FakeRepo([mathRoom, scienceRoom]),
    );

    final notification = AppNotification.fromJson(payloadNotification);
    final destination = await service.resolveDestination(notification);

    expect(destination.path, '/chat/6adcc7218df6140845e66317');
    expect(destination.extra, isA<ChatRouteArgs>());
    final args = destination.extra as ChatRouteArgs;
    expect(args.classroomName, 'samar - الرياضيات');
    expect(args.classroomId, '6adcc71f0f5958c8e31fd1db');
    expect(args.classroomSubjectId, '6adcc7200f5958c8e31fd1dc');
  });

  test('uses cached room synchronously and asynchronously when already loaded', () async {
    final cache = ChatRoomsCache(SessionManager.instance)..replace([mathRoom]);
    final service = NotificationNavigationService(
      SessionManager.instance,
      roomsCache: cache,
    );

    final notification = AppNotification.fromJson(payloadNotification);

    expect(service.resolve(notification), '/chat/6adcc7218df6140845e66317');

    final destination = await service.resolveDestination(notification);
    expect(destination.path, '/chat/6adcc7218df6140845e66317');
  });

  test('falls back to classroom_details route when room is not found and never uses classroomId as chatRoomId', () async {
    final service = NotificationNavigationService(
      SessionManager.instance,
      chatRepo: _FailingRepo(),
    );

    final notification = AppNotification.fromJson(payloadNotification);
    final destination = await service.resolveDestination(notification);

    expect(destination.path, isNot(contains('/chat/')));
    expect(destination.path, contains(Routes.studentSubjects));
    expect(destination.path, contains('classroomId=6adcc71f0f5958c8e31fd1db'));
    expect(destination.path, contains('classroomSubjectId=6adcc7200f5958c8e31fd1dc'));
    expect(destination.path, contains('subjectId=6a9b4af59fb900ca8a77798b'));
  });

  test('unauthenticated user falls back safely', () async {
    await SessionManager.instance.clearSession();
    final service = NotificationNavigationService(SessionManager.instance);

    final notification = AppNotification.fromJson(payloadNotification);
    final destination = await service.resolveDestination(notification);

    expect(destination.path, Routes.splash);
  });
}

class _FakeRepo extends Fake implements ChatRepo {
  _FakeRepo(this.rooms);
  final List<ChatRoomSummaryModel> rooms;

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async =>
      Right(ChatRoomsResponseModel(success: true, results: rooms.length, rooms: rooms));
}

class _FailingRepo extends Fake implements ChatRepo {
  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async =>
      Left(Failure(message: 'Network offline'));
}
