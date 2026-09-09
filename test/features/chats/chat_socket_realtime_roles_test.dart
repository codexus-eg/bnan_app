import 'package:flutter/foundation.dart';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_messages_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_rooms_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_room_messages_cubit/get_room_messages_state.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_requests_page.dart';
import 'package:bnan_app/features/classroom_change_requests/data/repo/classroom_change_requests_repo.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_cubit.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_state.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_response_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_state.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Socket Realtime Across Roles (Admin, Student, Parent, Teacher)', () {
    test('GetChatRoomsCubit updates unread badge and order on live message', () async {
      final repo = _FakeRepo();
      final cache = ChatRoomsCache(SessionManager.instance);
      final socket = _FakeSocket();
      final coordinator = ChatNotificationCoordinator(
        socket,
        alert: _NoopAlert(),
        currentUserId: () => 'user-admin',
      );
      await coordinator.start();

      final cubit = GetChatRoomsCubit(repo, coordinator, cache);
      await cubit.getChatRooms();

      expect(cubit.totalUnreadCount, 0);
      expect((cubit.state as GetChatRoomsSuccess).rooms.first.id, 'room-1');

      socket.emitMessage(
        _fakeMessage(id: 'msg-live-1', roomId: 'room-2', senderId: 'student-1', text: 'Hello Admin'),
      );
      await Future<void>.delayed(Duration.zero);

      final updatedState = cubit.state as GetChatRoomsSuccess;
      expect(cubit.totalUnreadCount, 1);
      expect(updatedState.rooms.first.id, 'room-2');
      expect(updatedState.rooms.first.lastMessage, 'Hello Admin');
      expect(updatedState.rooms.first.unreadCount, 1);

      await cubit.close();
      await coordinator.dispose();
    });

    test('GetChatRoomsCubit re-fetches when receiving message for untracked room', () async {
      final repo = _FakeRepo();
      final cache = ChatRoomsCache(SessionManager.instance);
      final socket = _FakeSocket();
      final coordinator = ChatNotificationCoordinator(
        socket,
        alert: _NoopAlert(),
        currentUserId: () => 'teacher-1',
      );
      await coordinator.start();

      final cubit = GetChatRoomsCubit(repo, coordinator, cache);
      await cubit.getChatRooms();
      expect(repo.getRoomsCallCount, 1);

      socket.emitMessage(
        _fakeMessage(id: 'msg-new-room', roomId: 'room-3', senderId: 'parent-1', text: 'New conversation'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(repo.getRoomsCallCount, 2);

      await cubit.close();
      await coordinator.dispose();
    });

    test('NotificationsCubit receives socket notification and updates unread count', () async {
      final repo = _FakeNotificationsRepo();
      final socket = _FakeSocket();
      final cubit = NotificationsCubit(repo, socket, RecentNotificationIds());

      cubit.ingestSocketNotification({
        'id': 'notif-1',
        'type': 'general',
        'key': 'ANNOUNCEMENT',
        'title': 'New Announcement',
        'body': 'School event tomorrow',
        'isRead': false,
      });

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.id, 'notif-1');
      expect(cubit.state.unreadCount, 1);

      await cubit.close();
    });

    test('GetRoomMessagesCubit receives message in realtime and adds to messages list', () async {
      final repo = _FakeRepo();
      final socket = _FakeSocket();
      final coordinator = ChatNotificationCoordinator(
        socket,
        alert: _NoopAlert(),
        currentUserId: () => 'student-1',
      );
      final cubit = GetRoomMessagesCubit(repo, socket, coordinator);

      await cubit.initializeChat(roomId: 'room-1');
      expect((cubit.state as GetRoomMessagesSuccess).messages, isEmpty);

      socket.emitMessage(
        _fakeMessage(id: 'msg-100', roomId: 'room-1', senderId: 'teacher-1', text: 'Class starts now'),
      );

      final state = cubit.state as GetRoomMessagesSuccess;
      expect(state.messages.length, 1);
      expect(state.messages.first.id, 'msg-100');
      expect(state.messages.first.text, 'Class starts now');

      await cubit.close();
      await coordinator.dispose();
    });

    test('Teacher accepts lesson request -> Group immediately appears for all roles without refresh', () async {
      final repo = _FakeRepo();
      final cache = ChatRoomsCache(SessionManager.instance);
      final socket = _FakeSocket();

      // Setup coordinator for student
      final studentCoordinator = ChatNotificationCoordinator(
        socket,
        alert: _NoopAlert(),
        currentUserId: () => 'student-1',
      );
      await studentCoordinator.start();

      final studentCubit = GetChatRoomsCubit(repo, studentCoordinator, cache);
      await studentCubit.getChatRooms();
      expect(repo.getRoomsCallCount, 1);

      // Teacher accepts lesson request and backend emits TEACHER_REQUEST_ACCEPTED notification or roomCreated event
      socket.emitNotification({
        'id': 'notif-accepted-1',
        'key': 'TEACHER_REQUEST_ACCEPTED',
        'notificationType': 'classroom',
        'data': {
          'roomId': 'room-new-classroom',
          'classroomId': 'classroom-1',
          'roomName': 'Math Grade 5',
          'message': 'Teacher accepted your request',
        },
      });
      await Future<void>.delayed(Duration.zero);

      // Student chat list immediately refreshed and fetched the newly created classroom group!
      expect(repo.getRoomsCallCount, 2);

      await studentCubit.close();
      await studentCoordinator.dispose();
    });

    test('Scenario 1: Student requests teacher change -> Admin notification + badge realtime', () async {
      final repo = _FakeNotificationsRepo();
      final socket = _FakeSocket();
      final cubit = NotificationsCubit(repo, socket, RecentNotificationIds());

      expect(cubit.state.unreadCount, 0);
      expect(cubit.state.items, isEmpty);

      cubit.ingestSocketNotification({
        'id': 'notif-change-req-1',
        'key': 'CLASSROOM_CHANGE_REQUESTED',
        'type': 'classroom',
        'title': 'Teacher Change Request',
        'body': 'Student A requested teacher change for Math Grade 5',
        'data': {
          'requestId': 'req-999',
          'classroomId': 'cls-888',
        },
        'isRead': false,
      });

      expect(cubit.state.unreadCount, 1);
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.key, 'CLASSROOM_CHANGE_REQUESTED');
      expect(cubit.state.items.first.navigation.params['requestId'], 'req-999');
      expect(cubit.state.items.first.navigation.params['classroomId'], 'cls-888');

      await cubit.close();
    });

    test('Scenario 1b: Admin on classroom_change_requests screen -> Student requests change -> List refreshes realtime', () async {
      final repo = _DynamicChangeRequestsRepo([
        const ClassroomChangeRequestModel(
          id: 'req-old',
          status: 'pending',
          requesterName: 'Student Previous',
          requesterType: 'student',
          classroomName: 'Grade 4 Math',
          subjectName: 'Math',
          classroomSubjectId: 'cs-old',
          notes: 'Old request',
          requestType: 'change_teacher',
        ),
      ]);
      final socket = _FakeSocket();
      final cubit = AdminChangeRequestsCubit(repo, socket);

      // Admin loads requests initially
      await cubit.load();
      expect(cubit.state, isA<AdminChangeRequestsSuccess>());
      final initialRequests = (cubit.state as AdminChangeRequestsSuccess).requests;
      expect(initialRequests.length, 1);
      expect(initialRequests.first.id, 'req-old');
      expect(repo.getRequestsCallCount, 1);

      // Student submits a new change request; backend adds it and emits CLASSROOM_CHANGE_REQUESTED
      repo.requests = [
        const ClassroomChangeRequestModel(
          id: 'req-new',
          status: 'pending',
          requesterName: 'Student New',
          requesterType: 'student',
          classroomName: 'Grade 5 Science',
          subjectName: 'Science',
          classroomSubjectId: 'cs-new',
          notes: 'Want another teacher',
          requestType: 'change_teacher',
        ),
        ...initialRequests,
      ];

      socket.emitNotification({
        'id': 'notif-req-new',
        'key': 'CLASSROOM_CHANGE_REQUESTED',
        'type': 'classroom',
        'data': {
          'requestId': 'req-new',
          'classroomId': 'cls-555',
        },
      });
      await Future<void>.delayed(Duration.zero);

      // AdminChangeRequestsCubit immediately reloaded and shows the new request without manual refresh
      expect(repo.getRequestsCallCount, 2);
      expect(cubit.state, isA<AdminChangeRequestsSuccess>());
      final updatedRequests = (cubit.state as AdminChangeRequestsSuccess).requests;
      expect(updatedRequests.length, 2);
      expect(updatedRequests.first.id, 'req-new');

      await cubit.close();
    });

    test('Scenario 2: Admin assigns new teacher -> 200 without 409 handling', () async {
      final repo = _FakeTeacherAssignmentRepo(
        assignResult: const Right(
          AssignTeacherResponseModel(
            success: true,
            message: 'Teacher reassigned successfully',
          ),
        ),
      );
      final cubit = TeacherSubjectAssignmentActionsCubit(repo);

      await cubit.assignTeacher(
        teacherId: 'teacher-new',
        curriculumId: 'curr-1',
        gradeId: 'gr-1',
        classroomId: 'cls-1',
        subjectId: 'sub-1',
      );

      expect(cubit.state, isA<AssignTeacherSuccess>());
      final successState = cubit.state as AssignTeacherSuccess;
      expect(successState.response.success, isTrue);
      expect(successState.response.message, 'Teacher reassigned successfully');

      await cubit.close();
    });

    test('Scenario 3: Teacher changed -> Student/Parent/New Teacher data + chat refresh realtime', () async {
      final repo = _FakeRepo();
      final cache = ChatRoomsCache(SessionManager.instance);
      final socket = _FakeSocket();

      final coordinator = ChatNotificationCoordinator(
        socket,
        alert: _NoopAlert(),
        currentUserId: () => 'student-1',
      );
      await coordinator.start();

      final cubit = GetChatRoomsCubit(repo, coordinator, cache);
      await cubit.getChatRooms();
      expect(repo.getRoomsCallCount, 1);

      // Backend emits CLASSROOM_TEACHER_CHANGED
      socket.emitNotification({
        'id': 'notif-teacher-changed-1',
        'key': 'CLASSROOM_TEACHER_CHANGED',
        'notificationType': 'classroom',
        'data': {
          'classroomId': 'cls-1',
          'classroomSubjectId': 'cs-1',
          'subjectId': 'sub-1',
          'teacherId': 'teacher-new',
        },
      });
      await Future<void>.delayed(Duration.zero);

      // Chat rooms immediately refreshed in realtime
      expect(repo.getRoomsCallCount, 2);

      await cubit.close();
      await coordinator.dispose();
    });

    test('Scenario 3b: User in classroom details -> Teacher changed -> ClassroomDetailsCubit refreshes realtime', () async {
      final repo = _DynamicClassroomsRepo(
        const ClassroomModel(
          id: 'cls-10',
          name: 'Grade 5 Math',
          curriculum: ClassroomLookupModel(id: 'curr-1', name: 'Curriculum 1'),
          grade: ClassroomLookupModel(id: 'gr-1', name: 'Grade 5'),
          teachers: [
            ClassroomTeacherModel(id: 'teacher-old', fullName: 'Mr. Old Teacher'),
          ],
          isActive: true,
          approvedStudentsCount: 20,
          assignedTeachersCount: 1,
        ),
      );
      final socket = _FakeSocket();
      final cubit = ClassroomDetailsCubit(repo, socket);

      // User opens classroom details
      await cubit.getClassroomDetails('cls-10');
      expect(cubit.state, isA<ClassroomDetailsSuccess>());
      final initialData = (cubit.state as ClassroomDetailsSuccess).response.data;
      expect(initialData.teachers.first.id, 'teacher-old');
      expect(initialData.teachers.first.fullName, 'Mr. Old Teacher');
      expect(repo.getDetailsCallCount, 1);

      // Admin reassigns subject to new teacher; backend emits CLASSROOM_TEACHER_CHANGED
      repo.classroom = const ClassroomModel(
        id: 'cls-10',
        name: 'Grade 5 Math',
        curriculum: ClassroomLookupModel(id: 'curr-1', name: 'Curriculum 1'),
        grade: ClassroomLookupModel(id: 'gr-1', name: 'Grade 5'),
        teachers: [
          ClassroomTeacherModel(id: 'teacher-new', fullName: 'Ms. New Teacher'),
        ],
        isActive: true,
        approvedStudentsCount: 20,
        assignedTeachersCount: 1,
      );

      socket.emitNotification({
        'id': 'notif-chg-10',
        'key': 'CLASSROOM_TEACHER_CHANGED',
        'type': 'classroom',
        'data': {
          'classroomId': 'cls-10',
          'classroomSubjectId': 'cs-10',
          'subjectId': 'sub-10',
          'teacherId': 'teacher-new',
        },
      });
      await Future<void>.delayed(Duration.zero);

      // ClassroomDetailsCubit reloaded silently and updated teacher data
      expect(repo.getDetailsCallCount, 2);
      expect(cubit.state, isA<ClassroomDetailsSuccess>());
      final updatedData = (cubit.state as ClassroomDetailsSuccess).response.data;
      expect(updatedData.teachers.first.id, 'teacher-new');
      expect(updatedData.teachers.first.fullName, 'Ms. New Teacher');

      await cubit.close();
    });

    test('Scenario 4: Old Teacher loses classroom/chat access without Refresh', () async {
      final repo = _DynamicRoomsRepo([
        const ChatRoomSummaryModel(
          id: 'room-math-cls1',
          type: 'classroom',
          displayName: 'Math Grade 5',
          subtitle: 'Active',
          unreadCount: 0,
        ),
        const ChatRoomSummaryModel(
          id: 'room-support',
          type: 'support',
          displayName: 'Admin Support',
          subtitle: '',
          unreadCount: 0,
        ),
      ]);
      final cache = ChatRoomsCache(SessionManager.instance);
      final socket = _FakeSocket();

      final oldTeacherCoordinator = ChatNotificationCoordinator(
        socket,
        alert: _NoopAlert(),
        currentUserId: () => 'teacher-old',
      );
      await oldTeacherCoordinator.start();

      final oldTeacherCubit = GetChatRoomsCubit(repo, oldTeacherCoordinator, cache);
      await oldTeacherCubit.getChatRooms();

      expect((oldTeacherCubit.state as GetChatRoomsSuccess).rooms.length, 2);
      expect((oldTeacherCubit.state as GetChatRoomsSuccess).rooms.any((r) => r.id == 'room-math-cls1'), isTrue);

      // Backend reassigned subject to another teacher -> Old teacher now only has access to room-support
      repo.rooms = [
        const ChatRoomSummaryModel(
          id: 'room-support',
          type: 'support',
          displayName: 'Admin Support',
          subtitle: '',
          unreadCount: 0,
        ),
      ];

      // Backend emits CLASSROOM_TEACHER_CHANGED notification
      socket.emitNotification({
        'id': 'notif-teacher-changed-2',
        'key': 'CLASSROOM_TEACHER_CHANGED',
        'notificationType': 'classroom',
        'data': {
          'classroomId': 'cls-1',
          'classroomSubjectId': 'cs-1',
          'subjectId': 'sub-1',
          'roomId': 'room-math-cls1',
        },
      });
      await Future<void>.delayed(Duration.zero);

      // Old teacher chat list immediately refreshed -> classroom room is gone
      final updatedState = oldTeacherCubit.state as GetChatRoomsSuccess;
      expect(updatedState.rooms.length, 1);
      expect(updatedState.rooms.any((r) => r.id == 'room-math-cls1'), isFalse);

      await oldTeacherCubit.close();
      await oldTeacherCoordinator.dispose();
    });

    test('Scenario 5: Admin on classrooms management screen -> Teacher changed/unassigned -> ClassroomsCubit reloads realtime', () async {
      final repo = _DynamicClassroomsRepo(
        const ClassroomModel(
          id: 'cls-1',
          name: 'Grade 1 Classroom',
          curriculum: ClassroomLookupModel(id: 'c1', name: 'Curriculum 1'),
          grade: ClassroomLookupModel(id: 'g1', name: 'Grade 1'),
          teachers: [ClassroomTeacherModel(id: 'teacher-old', fullName: 'Old Teacher')],
          isActive: true,
          approvedStudentsCount: 15,
          assignedTeachersCount: 1,
        ),
      );
      final socket = _FakeSocket();
      final cubit = ClassroomsCubit(repo, socket);

      // Admin views classrooms list
      await cubit.getClassrooms();
      expect(cubit.state, isA<ClassroomsSuccess>());
      expect((cubit.state as ClassroomsSuccess).response.data.first.teachers.first.id, 'teacher-old');
      expect(repo.getClassroomsCallCount, 1);

      // Backend changes teacher and emits notification
      repo.classrooms = [
        const ClassroomModel(
          id: 'cls-1',
          name: 'Grade 1 Classroom',
          curriculum: ClassroomLookupModel(id: 'c1', name: 'Curriculum 1'),
          grade: ClassroomLookupModel(id: 'g1', name: 'Grade 1'),
          teachers: [ClassroomTeacherModel(id: 'teacher-new', fullName: 'New Teacher')],
          isActive: true,
          approvedStudentsCount: 15,
          assignedTeachersCount: 1,
        ),
      ];

      socket.emitNotification({
        'id': 'notif-cls-reassign',
        'key': 'CLASSROOM_TEACHER_CHANGED',
        'type': 'classroom',
        'data': {'classroomId': 'cls-1', 'teacherId': 'teacher-new'},
      });
      await Future<void>.delayed(Duration.zero);

      // ClassroomsCubit refreshed silently and displays updated teacher
      expect(repo.getClassroomsCallCount, 2);
      expect(cubit.state, isA<ClassroomsSuccess>());
      expect((cubit.state as ClassroomsSuccess).response.data.first.teachers.first.id, 'teacher-new');

      await cubit.close();
    });

    test('Scenario 6: Security - Old teacher attempting to read or send message after unassignment is rejected with 403 Forbidden', () async {
      final repo = _ForbiddenChatRepo();
      final socket = _FakeSocket();
      final coordinator = ChatNotificationCoordinator(
        socket,
        alert: _NoopAlert(),
        currentUserId: () => 'teacher-old',
      );

      final messagesCubit = GetRoomMessagesCubit(repo, socket, coordinator);
      final sendCubit = SendMessageCubit(repo);

      // Old teacher tries to load messages of the unassigned room
      await messagesCubit.getRoomMessages(roomId: 'room-forbidden');
      expect(messagesCubit.state, isA<GetRoomMessagesFailure>());
      expect((messagesCubit.state as GetRoomMessagesFailure).errorMessage, contains('Forbidden'));

      // Old teacher tries to send message to the unassigned room
      await sendCubit.sendTextMessage(roomId: 'room-forbidden', text: 'Unauthorized message');
      expect(sendCubit.state, isA<SendMessageFailure>());
      expect((sendCubit.state as SendMessageFailure).errorMessage, contains('Forbidden'));

      await messagesCubit.close();
      await sendCubit.close();
      await coordinator.dispose();
    });
  });
}

ChatMessageModel _fakeMessage({
  required String id,
  required String roomId,
  required String senderId,
  required String text,
}) {
  return ChatMessageModel(
    id: id,
    roomId: roomId,
    sender: ChatSenderModel(id: senderId, fullName: 'Sender $senderId', role: 'student'),
    text: text,
    attachments: const <ChatAttachmentModel>[],
    messageType: 'text',
    deletedForEveryone: false,
    createdAt: DateTime.now(),
  );
}

class _NoopAlert implements ChatForegroundAlert {
  @override
  Future<void> play() async {}
}

class _FakeSocket extends SocketService {
  final List<void Function(ChatMessageModel)> _messageListeners = [];
  final List<void Function(Map<String, dynamic>)> _notificationListeners = [];
  final List<String> joinedRooms = [];

  @override
  bool get isConnected => true;

  @override
  Future<void> connect() async {}

  @override
  void joinRoom(String roomId) => joinedRooms.add(roomId);

  @override
  VoidCallback listenToNewMessage(void Function(ChatMessageModel message) onNewMessage) {
    _messageListeners.add(onNewMessage);
    return () => _messageListeners.remove(onNewMessage);
  }

  @override
  VoidCallback listenToNotification(void Function(Map<String, dynamic> notification) onNotification) {
    _notificationListeners.add(onNotification);
    return () => _notificationListeners.remove(onNotification);
  }

  void emitMessage(ChatMessageModel message) {
    for (final listener in List.of(_messageListeners)) {
      listener(message);
    }
  }

  void emitNotification(Map<String, dynamic> notif) {
    for (final listener in List.of(_notificationListeners)) {
      listener(notif);
    }
  }
}

class _FakeRepo implements ChatRepo {
  int getRoomsCallCount = 0;

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async {
    getRoomsCallCount++;
    return const Right(
      ChatRoomsResponseModel(
        success: true,
        results: 2,
        rooms: [
          ChatRoomSummaryModel(
            id: 'room-1',
            type: 'support',
            displayName: 'Room 1',
            subtitle: '',
            unreadCount: 0,
          ),
          ChatRoomSummaryModel(
            id: 'room-2',
            type: 'support',
            displayName: 'Room 2',
            subtitle: '',
            unreadCount: 0,
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getAdminChatRooms({String? search}) => getChatRooms();

  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({required String roomId}) async {
    return const Right(
      ChatMessagesResponseModel(success: true, results: 0, messages: []),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNotificationsRepo implements NotificationsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DynamicRoomsRepo implements ChatRepo {
  _DynamicRoomsRepo(this.rooms);
  List<ChatRoomSummaryModel> rooms;
  int getRoomsCallCount = 0;

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getChatRooms() async {
    getRoomsCallCount++;
    return Right(
      ChatRoomsResponseModel(
        success: true,
        results: rooms.length,
        rooms: List.of(rooms),
      ),
    );
  }

  @override
  Future<Either<Failure, ChatRoomsResponseModel>> getAdminChatRooms({String? search}) => getChatRooms();

  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({required String roomId}) async {
    return const Right(ChatMessagesResponseModel(success: true, results: 0, messages: []));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeTeacherAssignmentRepo implements TeacherSubjectAssignmentRepo {
  _FakeTeacherAssignmentRepo({required this.assignResult});
  final Either<Failure, AssignTeacherResponseModel> assignResult;

  @override
  Future<Either<Failure, AssignTeacherResponseModel>> assignTeacher({
    required String teacherId,
    required AssignTeacherRequestModel request,
  }) async {
    return assignResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DynamicChangeRequestsRepo implements ClassroomChangeRequestsRepo {
  _DynamicChangeRequestsRepo(this.requests);
  List<ClassroomChangeRequestModel> requests;
  int getRequestsCallCount = 0;

  @override
  Future<Either<Failure, ClassroomChangeRequestsPage>> getAdminRequests({
    String? status,
    String? classroomId,
    int? page,
    int? limit,
  }) async {
    getRequestsCallCount++;
    return Right(
      ClassroomChangeRequestsPage(
        requests: List.of(requests),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DynamicClassroomsRepo implements ClassroomsRepo {
  _DynamicClassroomsRepo(this.classroom) : classrooms = [classroom];
  ClassroomModel classroom;
  List<ClassroomModel> classrooms;
  int getDetailsCallCount = 0;
  int getClassroomsCallCount = 0;

  @override
  Future<Either<Failure, ClassroomDetailsResponseModel>> getClassroomDetails(String id) async {
    getDetailsCallCount++;
    return Right(ClassroomDetailsResponseModel(success: true, data: classroom));
  }

  @override
  Future<Either<Failure, ClassroomsResponseModel>> getClassrooms({
    int? page,
    int? limit,
    String? curriculum,
  }) async {
    getClassroomsCallCount++;
    return Right(
      ClassroomsResponseModel(
        success: true,
        results: classrooms.length,
        pagination: const ClassroomsPaginationModel(
          currentPage: 1,
          perPage: 10,
          total: 1,
          lastPage: 1,
        ),
        data: List.of(classrooms),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ForbiddenChatRepo implements ChatRepo {
  @override
  Future<Either<Failure, ChatMessagesResponseModel>> getRoomMessages({required String roomId}) async {
    return Left(Failure(message: 'Forbidden: You do not have access to this room', statusCode: 403));
  }

  @override
  Future<Either<Failure, ChatMessageResponseModel>> sendMessage({
    required String roomId,
    String? text,
    List<String>? attachmentPaths,
  }) async {
    return Left(Failure(message: 'Forbidden: You cannot send messages to this room', statusCode: 403));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
