import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_room_navigation.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_destination.dart';
import 'package:flutter/foundation.dart';

class NotificationNavigationService {
  const NotificationNavigationService(
    this._session, {
    ChatRepo? chatRepo,
    ChatRoomsCache? roomsCache,
  }) : _chatRepo = chatRepo,
       _roomsCache = roomsCache;
  final SessionManager _session;
  final ChatRepo? _chatRepo;
  final ChatRoomsCache? _roomsCache;

  Future<NotificationDestination> resolveDestination(
    AppNotification notification,
  ) async {
    if (_screen(notification) == 'chat_room') {
      return _chatDestination(notification);
    }
    return NotificationDestination(resolve(notification));
  }

  String resolve(AppNotification notification) {
    final screen = _screen(notification);
    final params = notification.navigation.params;
    final resourceId = notification.resourceId;
    final route = switch (screen) {
      'chat_room' => _required(Routes.chatPath, params['roomId'] ?? resourceId),
      'schedule' => _schedule(),
      'subscription' => _subscription(params['studentId']?.toString()),
      'certificates' => _certificates(),
      'parent_child_certificates' => Routes.parentCertificates,
      'student_evaluations' => Routes.weeklyEvaluations,
      'performance' => Routes.teacherPerformance,
      'registration_requests' => Routes.registrationRequests,
      'teacher_approval' => Routes.teacherApplication,
      'teacher_home' => Routes.teacherHome,
      'supervisor_classrooms' => Routes.supervisorClassRoomAssignment,
      'attendance' => Routes.attendance,
      'students' => Routes.studentClassroomAssignment,
      _ => null,
    };
    if (route != null) return route;
    if (kDebugMode) debugPrint('Unsupported notification target: $screen');
    return Routes.notification;
  }

  String _screen(AppNotification value) =>
      (value.navigation.screen ??
              value.navigation.target ??
              _eventScreens[value.key] ??
              '')
          .trim()
          .toLowerCase();

  Future<NotificationDestination> _chatDestination(
    AppNotification notification,
  ) async {
    final params = notification.navigation.params;
    final roomId = _text(params['roomId'] ?? notification.resourceId);
    if (roomId == null) {
      return const NotificationDestination(Routes.notification);
    }
    final payloadName = _roomName(params);
    var room = _roomsCache?.find(roomId);
    if (room == null && payloadName == null) {
      room = await _loadRoom(roomId);
    }
    final name = payloadName ?? _text(room?.displayName);
    final args = room == null
        ? ChatRouteArgs(classroomName: name, currentUserRole: _session.userRole)
        : ChatRoomNavigation.arguments(
            room,
            currentUserRole: _session.userRole,
            displayName: name,
          );
    return NotificationDestination(Routes.chatPath(roomId), extra: args);
  }

  Future<ChatRoomSummaryModel?> _loadRoom(String roomId) async {
    final repo = _chatRepo;
    if (repo == null) return null;
    final result = await repo.getChatRooms();
    return result.fold((_) => null, (response) {
      _roomsCache?.replace(response.rooms);
      return _roomsCache?.find(roomId) ?? _findRoom(response.rooms, roomId);
    });
  }

  String? _required(String Function(String) build, dynamic value) {
    final id = value?.toString().trim() ?? '';
    return id.isEmpty ? null : build(id);
  }

  String _schedule() => switch (_session.role) {
    UserRole.parent => Routes.parentSchedule,
    UserRole.student when _session.isGulfStudent =>
      Routes.gulfStudentScheduleReadOnly,
    UserRole.student ||
    UserRole.teacher ||
    UserRole.supervisor => Routes.egyptianSchedulesReadOnly,
    _ => Routes.tablesManagement,
  };
  String? _subscription(String? _) => switch (_session.role) {
    UserRole.student => Routes.studentSubscriptions,
    UserRole.parent => Routes.parentSubscriptions,
    _ => null,
  };
  String? _certificates() => switch (_session.role) {
    UserRole.parent || UserRole.student => Routes.parentCertificates,
    UserRole.supervisor => Routes.certificatesManagement,
    _ => null,
  };
}

const _eventScreens = <String, String>{
  'NEW_MESSAGE': 'chat_room',
  'CLASS_CANCELLED': 'schedule',
  'CLASS_RESCHEDULED': 'schedule',
  'CLASS_REMINDER': 'schedule',
  'HOMEWORK_CREATED': 'assignment_details',
  'HOMEWORK_GRADED': 'assignment_details',
  'EVALUATION_CREATED': 'student_evaluations',
  'PERFORMANCE_POINTS_EARNED': 'performance',
  'PAYMENT_SUCCESS': 'subscription',
  'SUBSCRIPTION_STARTED': 'subscription',
  'STUDENT_CERTIFICATE_ISSUED': 'certificates',
  'CHILD_CERTIFICATE_ISSUED': 'parent_child_certificates',
  'IDEAL_TEACHER_CERTIFICATE_ISSUED': 'certificates',
  'IDEAL_SUPERVISOR_CERTIFICATE_ISSUED': 'certificates',
  'EGYPTIAN_STUDENT_REGISTRATION_REQUEST': 'registration_requests',
  'EGYPTIAN_PAYMENT_CONFIRMED': 'registration_requests',
  'EGYPTIAN_REGISTRATION_APPROVED': 'registration_requests',
  'EGYPTIAN_REGISTRATION_REJECTED': 'registration_requests',
  'GULF_NEW_CUSTOMER_REGISTERED': 'students',
  'TEACHER_REGISTRATION_REQUEST': 'teacher_approval',
  'TEACHER_APPROVED': 'teacher_home',
  'TEACHER_REJECTED': 'teacher_home',
  'STUDENT_ABSENT': 'attendance',
  'STUDENT_LATE': 'attendance',
  'SUPERVISOR_CLASSROOM_ASSIGNED': 'supervisor_classrooms',
  'SUPERVISOR_CLASSROOM_UNASSIGNED': 'supervisor_classrooms',
};

String? _roomName(Map<String, dynamic> params) {
  for (final key in const ['roomName', 'chatName', 'name', 'title']) {
    final value = _text(params[key]);
    if (value != null) return value;
  }
  return null;
}

String? _text(dynamic value) {
  final text = value?.toString().trim();
  return text?.isNotEmpty == true ? text : null;
}

ChatRoomSummaryModel? _findRoom(
  Iterable<ChatRoomSummaryModel> rooms,
  String roomId,
) {
  for (final room in rooms) {
    if (room.id.trim() == roomId) return room;
  }
  return null;
}
