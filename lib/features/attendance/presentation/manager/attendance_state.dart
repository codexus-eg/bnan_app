import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';

enum AttendanceLoadTarget { none, classrooms, sessions, students }

class AttendanceState {
  const AttendanceState({
    this.allowed = true,
    this.classrooms = const [],
    this.grades = const [],
    this.sessions = const [],
    this.students = const [],
    this.statusByStudentId = const {},
    this.loadingClassrooms = false,
    this.loadingSessions = false,
    this.loadingStudents = false,
    this.submitting = false,
    this.selectedGradeId,
    this.selectedClassroomId,
    this.selectedSessionId,
    this.errorMessage,
    this.errorTarget = AttendanceLoadTarget.none,
    this.eventMessage,
    this.eventSuccess,
    this.eventId = 0,
  });

  final bool allowed,
      loadingClassrooms,
      loadingSessions,
      loadingStudents,
      submitting;
  final List<AttendanceClassroom> classrooms;
  final List<AttendanceGrade> grades;
  final List<AttendanceSession> sessions;
  final List<AttendanceStudent> students;
  final Map<String, AttendanceStatus> statusByStudentId;
  final String? selectedGradeId, selectedClassroomId, selectedSessionId;
  final String? errorMessage, eventMessage;
  final AttendanceLoadTarget errorTarget;
  final bool? eventSuccess;
  final int eventId;

  AttendanceState copyWith({
    bool? allowed,
    List<AttendanceClassroom>? classrooms,
    List<AttendanceGrade>? grades,
    List<AttendanceSession>? sessions,
    List<AttendanceStudent>? students,
    Map<String, AttendanceStatus>? statuses,
    bool? loadingClassrooms,
    bool? loadingSessions,
    bool? loadingStudents,
    bool? submitting,
    Object? gradeId = _unset,
    Object? classroomId = _unset,
    Object? sessionId = _unset,
    Object? errorMessage = _unset,
    AttendanceLoadTarget? errorTarget,
    String? eventMessage,
    bool? eventSuccess,
    int? eventId,
  }) => AttendanceState(
    allowed: allowed ?? this.allowed,
    classrooms: classrooms ?? this.classrooms,
    grades: grades ?? this.grades,
    sessions: sessions ?? this.sessions,
    students: students ?? this.students,
    statusByStudentId: statuses ?? statusByStudentId,
    loadingClassrooms: loadingClassrooms ?? this.loadingClassrooms,
    loadingSessions: loadingSessions ?? this.loadingSessions,
    loadingStudents: loadingStudents ?? this.loadingStudents,
    submitting: submitting ?? this.submitting,
    selectedGradeId: gradeId == _unset ? selectedGradeId : gradeId as String?,
    selectedClassroomId: classroomId == _unset
        ? selectedClassroomId
        : classroomId as String?,
    selectedSessionId: sessionId == _unset
        ? selectedSessionId
        : sessionId as String?,
    errorMessage: errorMessage == _unset
        ? this.errorMessage
        : errorMessage as String?,
    errorTarget: errorTarget ?? this.errorTarget,
    eventMessage: eventMessage,
    eventSuccess: eventSuccess,
    eventId: eventId ?? this.eventId,
  );
}

const _unset = Object();
