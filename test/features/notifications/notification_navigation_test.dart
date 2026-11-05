import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  test('deduplicates IDs with bounded cache', () {
    final recent = RecentNotificationIds(capacity: 2);
    expect(recent.claim('n1'), isTrue);
    expect(recent.claim('n1'), isFalse);
    recent.claim('n2');
    recent.claim('n3');
    expect(recent.claim('n1'), isTrue);
  });

  test('resolves chat and safely falls back for unknown screen', () async {
    await _saveRole(UserRole.student);
    final service = NotificationNavigationService(SessionManager.instance);
    expect(
      service.resolve(_value('chat_room', id: 'room/1')),
      '/chat/room%2F1',
    );
    expect(service.resolve(_value('future_screen')), Routes.home);
  });

  test('global key routes by broadcastId without notificationId', () async {
    final service = NotificationNavigationService(SessionManager.instance);
    final notification = AppNotification.fromJson({
      'key': 'GLOBAL_NOTIFICATION',
      'broadcastId': 'broadcast/1',
      'type': 'announcement',
    });

    final destination = await service.resolveDestination(notification);

    expect(destination.path, '/global_notification_details/broadcast%2F1');
    expect(destination.extra, same(notification));
  });

  test('announcement type alone keeps existing fallback flow', () async {
    await _saveRole(UserRole.student);
    final service = NotificationNavigationService(SessionManager.instance);
    final notification = AppNotification.fromJson({
      'key': 'PLATFORM_ANNOUNCEMENT',
      'type': 'announcement',
    });

    expect(await service.resolveDestination(notification), isNotNull);
    expect(service.resolve(notification), Routes.home);
  });

  test('CLASSROOM_CHANGE_REQUESTED resolves to registrationRequests with query params for Admin', () async {
    await _saveRole(UserRole.admin);
    final service = NotificationNavigationService(SessionManager.instance);
    final notification = AppNotification.fromJson({
      'id': 'notif-change-req',
      'key': 'CLASSROOM_CHANGE_REQUESTED',
      'data': {
        'requestId': 'req-123',
        'classroomId': 'cls-456',
      },
    });

    final route = service.resolve(notification);
    expect(route, contains(Routes.registrationRequests));
    expect(route, contains('requestId=req-123'));
    expect(route, contains('classroomId=cls-456'));
  });

  test('CLASSROOM_TEACHER_CHANGED resolves to classroom_details for student, teacher, admin', () async {
    final notification = AppNotification.fromJson({
      'id': 'notif-teacher-chg',
      'key': 'CLASSROOM_TEACHER_CHANGED',
      'data': {
        'classroomId': 'cls-10',
        'classroomSubjectId': 'cs-20',
        'subjectId': 'sub-30',
      },
    });

    await _saveRole(UserRole.student);
    final studentService = NotificationNavigationService(SessionManager.instance);
    final studentRoute = studentService.resolve(notification);
    expect(studentRoute, contains(Routes.studentSubjects));
    expect(studentRoute, contains('classroomId=cls-10'));
    expect(studentRoute, contains('classroomSubjectId=cs-20'));
    expect(studentRoute, contains('subjectId=sub-30'));

    await _saveRole(UserRole.teacher);
    final teacherService = NotificationNavigationService(SessionManager.instance);
    final teacherRoute = teacherService.resolve(notification);
    expect(teacherRoute, contains(Routes.teacherSections));
    expect(teacherRoute, contains('classroomId=cls-10'));

    await _saveRole(UserRole.admin);
    final adminService = NotificationNavigationService(SessionManager.instance);
    final adminRoute = adminService.resolve(notification);
    expect(adminRoute, contains(Routes.classRoomManagement));
    expect(adminRoute, contains('classroomId=cls-10'));
  });

  test('RECORDING_READY resolves to classroom_documents with classroomId query param', () async {
    final notification = AppNotification.fromJson({
      'id': '6acaac3a5ca275ef546e797e',
      'type': 'classroom',
      'key': 'RECORDING_READY',
      'title': 'التسجيل جاهز',
      'body': 'تسجيل حصة لغة عربية أصبح جاهزًا للمشاهدة.',
      'resource': {'id': '6acaa816299b3e6d855ac9b6', 'model': 'Session'},
      'navigation': {
        'screen': 'classroom_details',
        'target': 'classroom_details',
        'params': {
          'sessionId': '6acaa816299b3e6d855ac9b6',
          'classroomId': '6a9b63849fb900ca8a7779de',
          'subjectId': '6a9a08b06d1a2b341f3304a4',
        },
      },
    });

    await _saveRole(UserRole.teacher);
    final teacherService = NotificationNavigationService(SessionManager.instance);
    final teacherRoute = teacherService.resolve(notification);
    expect(teacherRoute, contains(Routes.classroomDocuments));
    expect(teacherRoute, contains('classroomId=6a9b63849fb900ca8a7779de'));

    final destination = await teacherService.resolveDestination(notification);
    expect(destination.path, Routes.classroomDocuments);
    expect(destination.extra, isA<ClassroomDocumentsRouteArgs>());
    final args = destination.extra as ClassroomDocumentsRouteArgs;
    expect(args.classroomId, '6a9b63849fb900ca8a7779de');
    expect(args.initialTab, ClassroomDocumentsTab.recordings);
    expect(args.currentUserRole, 'teacher');
  });

  for (final entry in const {
    UserRole.student: (screen: 'teacher_approval', home: Routes.home),
    UserRole.parent: (screen: 'performance', home: Routes.parentHome),
    UserRole.teacher: (screen: 'students', home: Routes.teacherHome),
    UserRole.supervisor: (
      screen: 'registration_requests',
      home: Routes.supervisorHome,
    ),
    UserRole.admin: (screen: 'subscription', home: Routes.adminHome),
  }.entries) {
    test('${entry.key.name} rejects another role notification route', () async {
      await _saveRole(entry.key);
      final service = NotificationNavigationService(SessionManager.instance);

      expect(service.resolve(_value(entry.value.screen)), entry.value.home);
    });
  }
}

Future<void> _saveRole(UserRole role) => SessionManager.instance.saveSession(
  accessToken: 'token',
  refreshToken: '',
  userRole: role.name,
);

AppNotification _value(String screen, {String? id}) =>
    AppNotification.fromJson({
      'id': 'n1',
      'key': 'ANY',
      'resource': {'id': id},
      'navigation': {'screen': screen},
    });
