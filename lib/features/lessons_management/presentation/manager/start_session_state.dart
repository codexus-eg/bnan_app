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
    this.scheduledClassroomIds = const {},
    this.dueLessonsByClassroom = const {},
    this.dueLessonsByChatRoom = const {},
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
  final Set<String> scheduledClassroomIds;
  final Map<String, ScheduledLessonData> dueLessonsByClassroom;
  final Map<String, ScheduledLessonData> dueLessonsByChatRoom;
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
  ScheduledLessonData? dueLesson({String? classroomId, String? roomId}) {
    final room = roomId?.trim() ?? '';
    final classroom = classroomId?.trim() ?? '';
    if (room.isNotEmpty && dueLessonsByChatRoom.containsKey(room)) {
      return dueLessonsByChatRoom[room];
    }
    if (classroom.isNotEmpty && dueLessonsByClassroom.containsKey(classroom)) {
      return dueLessonsByClassroom[classroom];
    }
    return null;
  }

  bool isScheduled({String? roomId, String? classroomId}) {
    final room = roomId?.trim() ?? '';
    final classroom = classroomId?.trim() ?? '';
    if (room.isNotEmpty && scheduledChatRoomIds.contains(room)) return true;
    if (classroom.isNotEmpty && scheduledClassroomIds.contains(classroom)) {
      return true;
    }
    if (dueLesson(classroomId: classroom, roomId: room) != null) return true;
    final activeData = classroom.isNotEmpty ? active(classroom) : null;
    if (activeData != null &&
        activeData.session.isScheduled &&
        (activeData.session.isStartAvailable || activeData.session.isDueNow)) {
      return true;
    }
    return false;
  }

  StartSessionState copyWith({
    Set<String>? loadingClassroomIds,
    Set<String>? checkingClassroomIds,
    Set<String>? joiningClassroomIds,
    Set<String>? endingClassroomIds,
    Set<String>? checkedClassroomIds,
    Map<String, StartSessionData>? startedByClassroom,
    Map<String, StartSessionData>? activeByClassroom,
    Set<String>? scheduledChatRoomIds,
    Set<String>? scheduledClassroomIds,
    Map<String, ScheduledLessonData>? dueLessonsByClassroom,
    Map<String, ScheduledLessonData>? dueLessonsByChatRoom,
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
    scheduledClassroomIds:
        scheduledClassroomIds ?? this.scheduledClassroomIds,
    dueLessonsByClassroom:
        dueLessonsByClassroom ?? this.dueLessonsByClassroom,
    dueLessonsByChatRoom:
        dueLessonsByChatRoom ?? this.dueLessonsByChatRoom,
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

class ScheduledLessonData {
  const ScheduledLessonData({
    required this.classroomId,
    this.system = 'gulf',
    this.classroomSubjectId,
    this.subjectId,
    this.chatRoomId,
    this.lessonId,
    this.occurrenceDate,
    this.occurrenceKey,
    this.weeklySlotKey,
    this.startTime,
    this.endTime,
    this.day,
  });

  final String classroomId;
  final String system;
  final String? classroomSubjectId;
  final String? subjectId;
  final String? chatRoomId;
  final String? lessonId;
  final String? occurrenceDate;
  final String? occurrenceKey;
  final String? weeklySlotKey;
  final String? startTime;
  final String? endTime;
  final String? day;

  bool get isGulf => system.trim().toLowerCase() == 'gulf';
  bool get isEgyptian => system.trim().toLowerCase() == 'egyptian';
}
