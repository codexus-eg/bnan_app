import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/app_routes/home_route_resolver.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/cache/chat_rooms_cache.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_room_navigation.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_destination.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/domain/schedule_sync_coordinator.dart';
import 'package:flutter/foundation.dart';

class NotificationNavigationService {
  const NotificationNavigationService(
    this._session, {
    ChatRepo? chatRepo,
    ChatRoomsCache? roomsCache,
    ScheduleSyncCoordinator? scheduleSync,
  }) : _chatRepo = chatRepo,
       _roomsCache = roomsCache,
       _scheduleSync = scheduleSync;
  final SessionManager _session;
  final ChatRepo? _chatRepo;
  final ChatRoomsCache? _roomsCache;
  final ScheduleSyncCoordinator? _scheduleSync;

  ScheduleSyncCoordinator? get _effectiveScheduleSync =>
      _scheduleSync ??
      (getIt.isRegistered<ScheduleSyncCoordinator>()
          ? getIt<ScheduleSyncCoordinator>()
          : null);

  static const _homePaths = <String>{
    Routes.home,
    Routes.teacherHome,
    Routes.adminHome,
    Routes.parentHome,
    Routes.supervisorHome,
  };

  static bool isHomeDestination(String path) => _homePaths.contains(path);

  Future<NotificationDestination> resolveDestination(
    AppNotification notification,
  ) async {
    final sync = _effectiveScheduleSync;
    if (sync != null && sync.isScheduleNotification(notification)) {
      sync.handleNotification(notification);
    }
    final key = notification.key.trim().toUpperCase();
    final role = _session.role;

    if (key == 'GLOBAL_NOTIFICATION') {
      final broadcastId = notification.broadcastId;
      if (broadcastId == null || broadcastId.isEmpty) {
        return NotificationDestination(_fallback());
      }
      return NotificationDestination(
        Routes.globalNotificationDetailsPath(broadcastId),
        extra: notification,
      );
    }

    if (role == UserRole.student && key == 'STUDENT_CALL_ALERT') {
      return const NotificationDestination(Routes.home);
    }

    if (key == 'STUDENT_ACCEPTED_IN_CLASSROOM') {
      return _studentAcceptedInClassroomDestination(notification);
    }

    final screen = _screen(notification);
    if (!_isAllowed(role, screen)) {
      return NotificationDestination(_fallback());
    }

    if (role == UserRole.supervisor) {
      if (key == 'IDEAL_SUPERVISOR_CERTIFICATE_ISSUED' ||
          key.contains('SUPERVISOR_CERTIFICATE')) {
        await _openSupervisorCertificate(notification);
        return const NotificationDestination(Routes.notification);
      }
      if (key == 'SUPERVISOR_CLASSROOM_ASSIGNED') {
        return _chatDestination(notification);
      }
    }

    if (screen == 'chat_room' ||
        screen == 'active_session' ||
        screen == 'session_summary') {
      return _chatDestination(notification);
    }
    if (screen == 'classroom_documents') {
      return _classroomDocumentsDestination(notification);
    }
    return NotificationDestination(resolve(notification));
  }

  String resolve(AppNotification notification) {
    final role = _session.role;
    final key = notification.key.trim().toUpperCase();
    if (key == 'STUDENT_ACCEPTED_IN_CLASSROOM') {
      if (!_isAllowed(role, 'classroom_details')) return _fallback();
      return _studentAcceptedInClassroomRoute(notification) ?? _fallback();
    }
    final screen = _screen(notification);
    if (!_isAllowed(role, screen)) return _fallback();
    final params = notification.navigation.params;
    final resourceId = notification.resourceId;

    if (role == UserRole.supervisor) {
      if (screen == 'supervisor_classrooms' ||
          screen == 'registration_requests' ||
          screen == 'teacher_approval' ||
          screen == 'students' ||
          screen == 'certificates') {
        return Routes.notification;
      }
    }

    final route = switch (screen) {
      'student_home' => Routes.home,
      'classroom_documents' => _classroomDocumentsRoute(params, resourceId),
      'chat_room' ||
      'active_session' ||
      'session_summary' =>
        _required(Routes.chatPath, params['roomId'] ?? resourceId),
      'schedule' => _schedule(notification),
      'subscription' => _subscription(params),
      'certificates' => _certificates(),
      'parent_child_certificates' => Routes.parentCertificates,
      'student_evaluations' => Routes.weeklyEvaluations,
      'performance' => Routes.teacherPerformance,
      'teacher_requests' ||
      'teacher_registration_requests' =>
        Routes.teacherRegistrationRequest,
      'registration_requests' || 'subject_requests' =>
        role == UserRole.teacher
            ? Routes.teacherRegistrationRequest
            : Routes.registrationRequests,
      'classroom_change_requests' =>
          _classroomChangeRequests(params, resourceId),
      'classroom_details' => _classroomDetails(params, resourceId),
      'teacher_approval' => Routes.teacherApplication,
      'teacher_home' => Routes.teacherHome,
      'supervisor_classrooms' => Routes.supervisorClassRoomAssignment,
      'attendance' => Routes.attendance,
      'students' => Routes.studentClassroomAssignment,
      _ => null,
    };
    if (route != null) return route;
    if (kDebugMode) debugPrint('Unsupported notification target: $screen');
    return _fallback();
  }

  String _screen(AppNotification value) {
    final direct =
        (value.navigation.screen ?? value.navigation.target)?.trim().toLowerCase();
    final keyUpper = value.key.trim().toUpperCase();
    final typeUpper = value.type.trim().toUpperCase();

    if (keyUpper == 'RECORDING_READY' ||
        keyUpper.contains('RECORDING') ||
        typeUpper.contains('RECORDING')) {
      return 'classroom_documents';
    }

    if (direct != null && direct.isNotEmpty) {
      if (direct == 'classroom_documents' ||
          direct == 'classroom_recordings' ||
          direct == 'recordings' ||
          direct == 'documents') {
        return 'classroom_documents';
      }
      if (direct == 'active_session' ||
          direct == 'session_summary' ||
          direct == 'session_details' ||
          direct == 'live_session' ||
          direct == 'chat_room') {
        return 'chat_room';
      }
      if (direct == 'teacher_requests' ||
          direct == 'teacher_request' ||
          direct == 'subject_requests' ||
          direct == 'subject_request' ||
          direct == 'teacher_registration_requests') {
        return _session.role == UserRole.teacher
            ? 'teacher_registration_requests'
            : 'registration_requests';
      }
      if (direct == 'classroom_schedule' || direct == 'classroom_schedules') {
        return 'schedule';
      }
      return direct;
    }

    if (keyUpper.isNotEmpty && _eventScreens.containsKey(keyUpper)) {
      return _eventScreens[keyUpper]!;
    }

    if (typeUpper.isNotEmpty && _eventScreens.containsKey(typeUpper)) {
      return _eventScreens[typeUpper]!;
    }

    if (keyUpper.contains('SESSION_START') ||
        keyUpper.contains('SESSION_END') ||
        keyUpper.contains('CLASSROOM_SESSION') ||
        keyUpper.contains('LIVE_SESSION') ||
        keyUpper.contains('CLASS_START') ||
        keyUpper.contains('CLASS_END') ||
        typeUpper.contains('SESSION_START') ||
        typeUpper.contains('SESSION_END') ||
        typeUpper.contains('CLASSROOM_SESSION') ||
        typeUpper.contains('LIVE_SESSION') ||
        typeUpper.contains('CLASS_START') ||
        typeUpper.contains('CLASS_END')) {
      return 'chat_room';
    }

    if (keyUpper.contains('STUDENT_SUBJECT_REQUEST') ||
        typeUpper.contains('STUDENT_SUBJECT_REQUEST') ||
        keyUpper.contains('SUBJECT_REQUEST') ||
        typeUpper.contains('SUBJECT_REQUEST')) {
      return _session.role == UserRole.teacher
          ? 'teacher_registration_requests'
          : 'registration_requests';
    }

    if (keyUpper.contains('SCHEDULE') ||
        typeUpper.contains('SCHEDULE') ||
        value.data['dedupeKey']?.toString().contains('schedule') == true) {
      return 'schedule';
    }

    final text = '${value.title} ${value.body}';
    if (text.contains('بدأت الحصة') ||
        text.contains('بدء الحصة') ||
        text.contains('انتهت الحصة') ||
        text.contains('انتهاء الحصة') ||
        text.contains('حصة مباشرة') ||
        text.contains('بدأت الجلسة') ||
        text.contains('انتهت الجلسة')) {
      return 'chat_room';
    }

    if (text.contains('طلب مادة') ||
        text.contains('طلب تسجيل') ||
        text.contains('طلبات المواد')) {
      return _session.role == UserRole.teacher
          ? 'teacher_registration_requests'
          : 'registration_requests';
    }

    if (text.contains('جدول الفصل') ||
        text.contains('تحديد جدول') ||
        text.contains('تحديث جدول') ||
        text.contains('الجدول الدراسي')) {
      return 'schedule';
    }

    if (text.contains('تسجيل') || text.contains('التسجيل جاهز')) {
      return 'classroom_documents';
    }

    return '';
  }

  Future<void> _openSupervisorCertificate(AppNotification notification) async {
    final params = notification.navigation.params;
    final data = notification.data;
    final certObj = data['certificate'] is Map
        ? Map<String, dynamic>.from(data['certificate'] as Map)
        : const <String, dynamic>{};

    final candidate = _text(
      params['certificateUrl'] ??
          params['fileUrl'] ??
          params['pdfUrl'] ??
          params['url'] ??
          params['link'] ??
          data['certificateUrl'] ??
          data['fileUrl'] ??
          data['pdfUrl'] ??
          data['url'] ??
          data['link'] ??
          certObj['url'] ??
          certObj['fileUrl'] ??
          certObj['pdfUrl'],
    );

    if (candidate != null && FileUrlLauncher.isValidWebUrl(candidate)) {
      await FileUrlLauncher.open(candidate);
    }
  }

  Future<NotificationDestination> _chatDestination(
    AppNotification notification,
  ) async {
    final params = notification.navigation.params;
    final data = notification.data;
    final targetId = _extractChatTargetId(notification);
    if (targetId == null || targetId.isEmpty) {
      return NotificationDestination(_fallback());
    }
    final payloadName = _roomName(params) ?? _roomName(data);
    var room = _roomsCache?.find(targetId);
    room ??= await _loadRoom(targetId);
    final explicitRoomId = _text(
      params['roomId'] ??
          params['chatRoomId'] ??
          data['roomId'] ??
          data['chatRoomId'] ??
          params['room_id'] ??
          data['room_id'],
    );
    final roomId = room?.id ?? explicitRoomId;
    if (roomId == null || roomId.isEmpty) {
      return NotificationDestination(_fallback());
    }
    final name = payloadName ?? _text(room?.displayName);
    final targetMessageId = _text(
      params['targetMessageId'] ??
          params['messageId'] ??
          data['targetMessageId'] ??
          data['messageId'] ??
          (notification.key.trim().toUpperCase() == 'NEW_MESSAGE'
              ? notification.id
              : null),
    );
    final args = room == null
        ? ChatRouteArgs(
            classroomName: name,
            currentUserRole: _session.userRole,
            targetMessageId: targetMessageId,
          )
        : ChatRoomNavigation.arguments(
            room,
            currentUserRole: _session.userRole,
            displayName: name,
            targetMessageId: targetMessageId,
          );
    return NotificationDestination(Routes.chatPath(roomId), extra: args);
  }

  String? _extractChatTargetId(AppNotification notification) {
    final params = notification.navigation.params;
    final data = notification.data;
    final direct = _text(
      params['roomId'] ??
          params['chatRoomId'] ??
          data['roomId'] ??
          data['chatRoomId'] ??
          params['classroomId'] ??
          data['classroomId'] ??
          params['room_id'] ??
          data['room_id'] ??
          params['classroom_id'] ??
          data['classroom_id'] ??
          notification.resourceId,
    );
    if (direct != null) return direct;

    for (final source in [data, params]) {
      final classroom = source['classroom'];
      if (classroom is Map) {
        final id = _text(classroom['id'] ?? classroom['_id']);
        if (id != null) return id;
      }
      final room = source['room'] ?? source['chatRoom'];
      if (room is Map) {
        final id = _text(room['id'] ?? room['_id']);
        if (id != null) return id;
      }
    }
    return null;
  }

  Future<ChatRoomSummaryModel?> _loadRoom(String targetId) async {
    final repo = _chatRepo;
    if (repo == null) return null;
    final result = await repo.getChatRooms();
    return result.fold((_) => null, (response) {
      _roomsCache?.replace(response.rooms);
      return _roomsCache?.find(targetId) ?? _findRoom(response.rooms, targetId);
    });
  }

  Future<ChatRoomSummaryModel?> _loadRoomByClassroom({
    required String classroomId,
    String? classroomSubjectId,
  }) async {
    final repo = _chatRepo;
    if (repo == null) return null;
    final result = await repo.getChatRooms();
    return result.fold((_) => null, (response) {
      _roomsCache?.replace(response.rooms);
      return _roomsCache?.findByClassroom(
            classroomId: classroomId,
            classroomSubjectId: classroomSubjectId,
          ) ??
          ChatRoomsCache.findRoomByClassroom(
            response.rooms,
            classroomId: classroomId,
            classroomSubjectId: classroomSubjectId,
          );
    });
  }

  Future<NotificationDestination> _studentAcceptedInClassroomDestination(
    AppNotification notification,
  ) async {
    final role = _session.role;
    if (!_isAllowed(role, 'classroom_details')) {
      return NotificationDestination(_fallback());
    }

    final params = notification.navigation.params;
    final data = notification.data;
    final resourceId = notification.resourceId;

    final classroomId = _text(
      params['classroomId'] ??
          data['classroomId'] ??
          params['classroom_id'] ??
          data['classroom_id'] ??
          (notification.resourceModel?.toLowerCase() == 'classroom'
              ? resourceId
              : null),
    );

    final classroomSubjectId = _text(
      params['classroomSubjectId'] ??
          data['classroomSubjectId'] ??
          params['classroom_subject_id'] ??
          data['classroom_subject_id'],
    );

    ChatRoomSummaryModel? room;
    if (classroomId != null && classroomId.isNotEmpty) {
      room = _roomsCache?.findByClassroom(
        classroomId: classroomId,
        classroomSubjectId: classroomSubjectId,
      );
      room ??= await _loadRoomByClassroom(
        classroomId: classroomId,
        classroomSubjectId: classroomSubjectId,
      );
    }

    if (room != null && room.id.trim().isNotEmpty) {
      final payloadName = _roomName(params) ?? _roomName(data);
      final name = payloadName ?? _text(room.displayName);
      final targetMessageId = _text(
        params['targetMessageId'] ??
            params['messageId'] ??
            data['targetMessageId'] ??
            data['messageId'],
      );
      final args = ChatRoomNavigation.arguments(
        room,
        currentUserRole: _session.userRole,
        displayName: name,
        targetMessageId: targetMessageId,
      );
      return NotificationDestination(Routes.chatPath(room.id), extra: args);
    }

    final fallback = _classroomDetails(params, resourceId);
    if (fallback != null) {
      return NotificationDestination(fallback);
    }
    return NotificationDestination(_fallback());
  }

  String? _studentAcceptedInClassroomRoute(AppNotification notification) {
    final params = notification.navigation.params;
    final data = notification.data;
    final resourceId = notification.resourceId;

    final classroomId = _text(
      params['classroomId'] ??
          data['classroomId'] ??
          params['classroom_id'] ??
          data['classroom_id'] ??
          (notification.resourceModel?.toLowerCase() == 'classroom'
              ? resourceId
              : null),
    );

    final classroomSubjectId = _text(
      params['classroomSubjectId'] ??
          data['classroomSubjectId'] ??
          params['classroom_subject_id'] ??
          data['classroom_subject_id'],
    );

    if (classroomId != null && classroomId.isNotEmpty) {
      final room = _roomsCache?.findByClassroom(
        classroomId: classroomId,
        classroomSubjectId: classroomSubjectId,
      );
      if (room != null && room.id.trim().isNotEmpty) {
        return Routes.chatPath(room.id);
      }
    }

    return _classroomDetails(params, resourceId);
  }

  String? _required(String Function(String) build, dynamic value) {
    final id = value?.toString().trim() ?? '';
    return id.isEmpty ? null : build(id);
  }

  String _schedule([AppNotification? notification]) {
    if (notification != null) {
      _effectiveScheduleSync?.handleNotification(notification);
    }
    final dedupeKey =
        notification?.data['dedupeKey']?.toString().toLowerCase() ?? '';
    final registrationMode = (notification?.navigation.params['registrationMode'] ??
            notification?.data['registrationMode'])
        ?.toString()
        .toLowerCase();
    final isGulf = dedupeKey.contains('gulf') ||
        registrationMode == 'gulf' ||
        notification?.key.toUpperCase().contains('GULF') == true;

    return switch (_session.role) {
      UserRole.parent => Routes.parentSchedule,
      UserRole.student when isGulf || _session.isGulfStudent =>
        Routes.gulfStudentScheduleReadOnly,
      UserRole.teacher when isGulf || _session.hasGulfRegistration =>
        Routes.lessonsManagement,
      UserRole.student || UserRole.teacher => Routes.egyptianSchedulesReadOnly,
      UserRole.supervisor when isGulf || _session.isGulfSupervisor =>
        Routes.lessonsManagement,
      UserRole.supervisor => Routes.tablesManagement,
      _ => Routes.tablesManagement,
    };
  }
  String? _subscription(Map<String, dynamic> params) {
    final route = switch (_session.role) {
      UserRole.student => Routes.studentSubscriptions,
      UserRole.parent => Routes.parentSubscriptions,
      _ => null,
    };
    if (route == null) return null;
    final query = <String, String>{
      if (_text(params['studentId']) case final value?) 'studentId': value,
      if (_text(params['subscriptionId']) case final value?)
        'subscriptionId': value,
    };
    return query.isEmpty
        ? route
        : Uri(path: route, queryParameters: query).toString();
  }

  String? _classroomChangeRequests(
    Map<String, dynamic> params,
    String? resourceId,
  ) {
    final requestId = _text(params['requestId'] ?? resourceId);
    final classroomId = _text(params['classroomId']);
    final query = <String, String>{
      if (requestId != null) 'requestId': requestId,
      if (classroomId != null) 'classroomId': classroomId,
    };
    return query.isEmpty
        ? Routes.registrationRequests
        : Uri(
            path: Routes.registrationRequests,
            queryParameters: query,
          ).toString();
  }

  String? _classroomDetails(
    Map<String, dynamic> params,
    String? resourceId,
  ) {
    final classroomId = _text(params['classroomId'] ?? resourceId);
    final classroomSubjectId = _text(params['classroomSubjectId']);
    final subjectId = _text(params['subjectId']);
    final query = <String, String>{
      if (classroomId != null) 'classroomId': classroomId,
      if (classroomSubjectId != null) 'classroomSubjectId': classroomSubjectId,
      if (subjectId != null) 'subjectId': subjectId,
    };
    final baseRoute = switch (_session.role) {
      UserRole.student || UserRole.parent => Routes.studentSubjects,
      UserRole.teacher => Routes.teacherSections,
      UserRole.supervisor => Routes.supervisorClassRoomAssignment,
      UserRole.admin => Routes.classRoomManagement,
      _ => null,
    };
    if (baseRoute == null) return null;
    return query.isEmpty
        ? baseRoute
        : Uri(path: baseRoute, queryParameters: query).toString();
  }

  String? _certificates() => switch (_session.role) {
    UserRole.parent || UserRole.student => Routes.parentCertificates,
    UserRole.supervisor || UserRole.teacher => Routes.certificatesManagement,
    _ => null,
  };

  Future<NotificationDestination> _classroomDocumentsDestination(
    AppNotification notification,
  ) async {
    final classroomId = _extractClassroomId(notification);
    if (classroomId == null || classroomId.isEmpty) {
      return NotificationDestination(_fallback());
    }

    final params = notification.navigation.params;
    final data = notification.data;
    final targetId = _extractChatTargetId(notification) ?? classroomId;
    var room = _roomsCache?.find(targetId);
    room ??= await _loadRoom(targetId);

    final explicitRoomId = _text(
      params['roomId'] ??
          params['chatRoomId'] ??
          data['roomId'] ??
          data['chatRoomId'] ??
          params['room_id'] ??
          data['room_id'],
    );
    final roomId = room?.id ?? explicitRoomId ?? targetId;
    final payloadName = _roomName(params) ?? _roomName(data);
    final name = payloadName ?? _text(room?.displayName);
    final roomType = _text(params['roomType'] ?? data['roomType']) ??
        (room?.type.isNotEmpty == true ? room!.type : 'classroom');

    final args = ClassroomDocumentsRouteArgs(
      roomId: roomId,
      roomType: roomType,
      currentUserRole: _session.userRole,
      classroomId: classroomId,
      classroomName: name,
      initialTab: ClassroomDocumentsTab.recordings,
    );

    return NotificationDestination(Routes.classroomDocuments, extra: args);
  }

  String? _classroomDocumentsRoute(
    Map<String, dynamic> params,
    String? resourceId,
  ) {
    final classroomId = _text(params['classroomId'] ?? resourceId);
    if (classroomId == null || classroomId.isEmpty) return null;
    return Uri(
      path: Routes.classroomDocuments,
      queryParameters: {'classroomId': classroomId},
    ).toString();
  }

  String? _extractClassroomId(AppNotification notification) {
    final params = notification.navigation.params;
    final data = notification.data;
    final direct = _text(
      params['classroomId'] ??
          data['classroomId'] ??
          params['classroom_id'] ??
          data['classroom_id'],
    );
    if (direct != null && direct.isNotEmpty) return direct;

    final classroom = data['classroom'] ?? params['classroom'];
    if (classroom is Map) {
      final id = _text(classroom['id'] ?? classroom['_id']);
      if (id != null && id.isNotEmpty) return id;
    }

    if (notification.resourceModel?.trim().toLowerCase() == 'classroom') {
      final resId = notification.resourceId?.trim();
      if (resId != null && resId.isNotEmpty) return resId;
    }
    return null;
  }

  bool _isAllowed(UserRole? role, String screen) =>
      role != null && (_allowedScreens[role]?.contains(screen) ?? false);

  String _fallback() =>
      HomeRouteResolver.forRole(_session.userRole) ?? Routes.splash;
}

const _allowedScreens = <UserRole, Set<String>>{
  UserRole.student: {
    'student_home',
    'chat_room',
    'active_session',
    'session_summary',
    'schedule',
    'subscription',
    'certificates',
    'student_evaluations',
    'classroom_details',
    'classroom_documents',
  },
  UserRole.parent: {
    'chat_room',
    'active_session',
    'session_summary',
    'schedule',
    'subscription',
    'certificates',
    'parent_child_certificates',
    'student_evaluations',
    'classroom_details',
    'classroom_documents',
  },
  UserRole.teacher: {
    'chat_room',
    'active_session',
    'session_summary',
    'schedule',
    'performance',
    'teacher_home',
    'attendance',
    'classroom_details',
    'classroom_documents',
    'registration_requests',
    'teacher_registration_requests',
    'teacher_requests',
    'subject_requests',
  },
  UserRole.supervisor: {
    'chat_room',
    'active_session',
    'session_summary',
    'schedule',
    'certificates',
    'supervisor_classrooms',
    'attendance',
    'classroom_details',
    'classroom_documents',
  },
  UserRole.admin: {
    'chat_room',
    'active_session',
    'session_summary',
    'schedule',
    'registration_requests',
    'classroom_change_requests',
    'classroom_details',
    'classroom_documents',
    'teacher_approval',
    'students',
  },
};

const _eventScreens = <String, String>{
  'RECORDING_READY': 'classroom_documents',
  'RECORDING_COMPLETED': 'classroom_documents',
  'RECORDING_PROCESSED': 'classroom_documents',
  'SESSION_RECORDING_READY': 'classroom_documents',
  'CLASSROOM_RECORDING_READY': 'classroom_documents',
  'NEW_MESSAGE': 'chat_room',
  'SESSION_STARTED': 'chat_room',
  'SESSION_ENDED': 'chat_room',
  'CLASSROOM_SESSION_STARTED': 'chat_room',
  'CLASSROOM_SESSION_ENDED': 'chat_room',
  'LIVE_SESSION_STARTED': 'chat_room',
  'LIVE_SESSION_ENDED': 'chat_room',
  'SESSION_START': 'chat_room',
  'SESSION_END': 'chat_room',
  'START_SESSION': 'chat_room',
  'END_SESSION': 'chat_room',
  'LESSON_STARTED': 'chat_room',
  'LESSON_ENDED': 'chat_room',
  'CLASS_STARTED': 'chat_room',
  'CLASS_ENDED': 'chat_room',
  'NEW_SUBJECT_REQUEST': 'registration_requests',
  'SUBJECT_REQUEST_CREATED': 'registration_requests',
  'TEACHER_SUBJECT_REQUEST': 'registration_requests',
  'SUBJECT_REQUEST': 'registration_requests',
  'STUDENT_SUBJECT_REQUEST': 'registration_requests',
  'NEW_REGISTRATION_REQUEST': 'registration_requests',
  'STUDENT_SUBJECT_REQUESTED': 'teacher_registration_requests',
  'CLASSROOM_SCHEDULE_SET': 'schedule',
  'CLASSROOM_SCHEDULE_CREATED': 'schedule',
  'SCHEDULE_SET': 'schedule',
  'SCHEDULE_UPDATED': 'schedule',
  'CLASSROOM_SCHEDULE_UPDATED': 'schedule',
  'CLASS_SCHEDULE_UPDATED': 'schedule',
  'GULF_SCHEDULE_SET': 'schedule',
  'EGYPTIAN_SCHEDULE_SET': 'schedule',
  'CLASS_CANCELLED': 'schedule',
  'CLASS_RESCHEDULED': 'schedule',
  'CLASS_REMINDER': 'schedule',
  'CLASSROOM_CHANGE_REQUESTED': 'classroom_change_requests',
  'CLASSROOM_TEACHER_CHANGED': 'classroom_details',
  'HOMEWORK_CREATED': 'assignment_details',
  'HOMEWORK_GRADED': 'assignment_details',
  'EVALUATION_CREATED': 'student_evaluations',
  'PERFORMANCE_POINTS_EARNED': 'performance',
  'PAYMENT_SUCCESS': 'subscription',
  'SUBSCRIPTION_STARTED': 'subscription',
  'SUBSCRIPTION_EXPIRES_SOON': 'subscription',
  'SUBSCRIPTION_HOURS_LOW': 'subscription',
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
  'STUDENT_ACCEPTED_IN_CLASSROOM': 'classroom_details',
};

String? _roomName(Map<String, dynamic> params) {
  for (final key in const [
    'roomName',
    'chatName',
    'classroomName',
    'subjectName',
    'name',
    'title',
  ]) {
    final value = _text(params[key]);
    if (value != null) return value;
  }
  final classroom = params['classroom'];
  if (classroom is Map) {
    final name = _text(classroom['name'] ?? classroom['title']);
    if (name != null) return name;
  }
  return null;
}

String? _text(dynamic value) {
  final text = value?.toString().trim();
  return text?.isNotEmpty == true ? text : null;
}

ChatRoomSummaryModel? _findRoom(
  Iterable<ChatRoomSummaryModel> rooms,
  String targetId,
) {
  final target = targetId.trim();
  if (target.isEmpty) return null;
  for (final room in rooms) {
    if (room.id.trim() == target || room.classroomId?.trim() == target) {
      return room;
    }
  }
  return null;
}
