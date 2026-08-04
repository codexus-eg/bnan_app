import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';

enum StartSessionIssue { missingClassroom, missingSubject }

class StartSessionState {
  const StartSessionState({
    this.loadingClassroomIds = const {},
    this.startedByClassroom = const {},
    this.eventClassroomId,
    this.eventError,
    this.eventIssue,
    this.eventSuccess = false,
    this.eventId = 0,
  });

  final Set<String> loadingClassroomIds;
  final Map<String, StartSessionData> startedByClassroom;
  final String? eventClassroomId, eventError;
  final StartSessionIssue? eventIssue;
  final bool eventSuccess;
  final int eventId;

  bool isLoading(String classroomId) =>
      loadingClassroomIds.contains(classroomId);
  StartSessionData? started(String classroomId) =>
      startedByClassroom[classroomId];

  StartSessionState copyWith({
    Set<String>? loadingClassroomIds,
    Map<String, StartSessionData>? startedByClassroom,
    Object? eventClassroomId = _unset,
    Object? eventError = _unset,
    Object? eventIssue = _unset,
    bool? eventSuccess,
    int? eventId,
  }) => StartSessionState(
    loadingClassroomIds: loadingClassroomIds ?? this.loadingClassroomIds,
    startedByClassroom: startedByClassroom ?? this.startedByClassroom,
    eventClassroomId: eventClassroomId == _unset
        ? this.eventClassroomId
        : eventClassroomId as String?,
    eventError: eventError == _unset ? this.eventError : eventError as String?,
    eventIssue: eventIssue == _unset
        ? this.eventIssue
        : eventIssue as StartSessionIssue?,
    eventSuccess: eventSuccess ?? this.eventSuccess,
    eventId: eventId ?? this.eventId,
  );
}

const _unset = Object();
