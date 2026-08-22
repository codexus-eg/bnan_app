import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';

enum StartSessionIssue { missingClassroom, missingSubject }

class StartSessionState {
  const StartSessionState({
    this.loadingClassroomIds = const {},
    this.checkingClassroomIds = const {},
    this.joiningClassroomIds = const {},
    this.endingClassroomIds = const {},
    this.checkedClassroomIds = const {},
    this.startedByClassroom = const {},
    this.activeByClassroom = const {},
    this.scheduledChatRoomIds = const {},
    this.eventClassroomId,
    this.eventError,
    this.eventCode,
    this.eventStatusCode,
    this.eventIssue,
    this.eventSuccess = false,
    this.eventId = 0,
  });

  final Set<String> loadingClassroomIds;
  final Set<String> checkingClassroomIds;
  final Set<String> joiningClassroomIds;
  final Set<String> endingClassroomIds;
  final Set<String> checkedClassroomIds;
  final Map<String, StartSessionData> startedByClassroom;
  final Map<String, StartSessionData> activeByClassroom;
  // chatRoomIds الخاصة بالحصص المجدولة والمستحقة للمعلم
  final Set<String> scheduledChatRoomIds;
  final String? eventClassroomId, eventError, eventCode;
  final int? eventStatusCode;
  final StartSessionIssue? eventIssue;
  final bool eventSuccess;
  final int eventId;

  bool isLoading(String classroomId) =>
      loadingClassroomIds.contains(classroomId) ||
      joiningClassroomIds.contains(classroomId) ||
      endingClassroomIds.contains(classroomId);
  bool isChecking(String classroomId) =>
      checkingClassroomIds.contains(classroomId);
  StartSessionData? started(String classroomId) =>
      startedByClassroom[classroomId];
  StartSessionData? active(String classroomId) =>
      activeByClassroom[classroomId];
  bool isScheduledChat(String roomId) =>
      roomId.trim().isNotEmpty && scheduledChatRoomIds.contains(roomId.trim());

  StartSessionState copyWith({
    Set<String>? loadingClassroomIds,
    Set<String>? checkingClassroomIds,
    Set<String>? joiningClassroomIds,
    Set<String>? endingClassroomIds,
    Set<String>? checkedClassroomIds,
    Map<String, StartSessionData>? startedByClassroom,
    Map<String, StartSessionData>? activeByClassroom,
    Set<String>? scheduledChatRoomIds,
    Object? eventClassroomId = _unset,
    Object? eventError = _unset,
    Object? eventCode = _unset,
    Object? eventStatusCode = _unset,
    Object? eventIssue = _unset,
    bool? eventSuccess,
    int? eventId,
  }) => StartSessionState(
    loadingClassroomIds: loadingClassroomIds ?? this.loadingClassroomIds,
    checkingClassroomIds: checkingClassroomIds ?? this.checkingClassroomIds,
    joiningClassroomIds: joiningClassroomIds ?? this.joiningClassroomIds,
    endingClassroomIds: endingClassroomIds ?? this.endingClassroomIds,
    checkedClassroomIds: checkedClassroomIds ?? this.checkedClassroomIds,
    startedByClassroom: startedByClassroom ?? this.startedByClassroom,
    activeByClassroom: activeByClassroom ?? this.activeByClassroom,
    scheduledChatRoomIds: scheduledChatRoomIds ?? this.scheduledChatRoomIds,
    eventClassroomId: eventClassroomId == _unset
        ? this.eventClassroomId
        : eventClassroomId as String?,
    eventError: eventError == _unset ? this.eventError : eventError as String?,
    eventCode: eventCode == _unset ? this.eventCode : eventCode as String?,
    eventStatusCode: eventStatusCode == _unset
        ? this.eventStatusCode
        : eventStatusCode as int?,
    eventIssue: eventIssue == _unset
        ? this.eventIssue
        : eventIssue as StartSessionIssue?,
    eventSuccess: eventSuccess ?? this.eventSuccess,
    eventId: eventId ?? this.eventId,
  );
}

const _unset = Object();
