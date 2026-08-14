import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:flutter/foundation.dart';

class NotificationNavigationService {
  const NotificationNavigationService(this._session);
  final SessionManager _session;

  String resolve(AppNotification notification) {
    final screen =
        (notification.navigation.screen ??
                notification.navigation.target ??
                _eventScreens[notification.key] ??
                '')
            .trim()
            .toLowerCase();
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
