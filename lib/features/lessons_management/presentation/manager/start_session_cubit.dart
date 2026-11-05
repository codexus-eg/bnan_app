import 'dart:async';

import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

class StartSessionCubit extends Cubit<StartSessionState> {
  StartSessionCubit(
    this.repo,
    this.gulfScheduleRepo,
    this.tableManagementRepo, [
    this.chatRepo,
  ]) : super(const StartSessionState());
  final StartSessionRepo repo;
  final GulfScheduleRepo gulfScheduleRepo;
  final TableManagementRepo tableManagementRepo;
  final ChatRepo? chatRepo;
  final Map<String, int> _requestIds = {};
  final Map<String, int> _activeRequestIds = {};
  int _scheduleRequestId = 0;
  static bool _timezonesInitialized = false;

  /// جلب الحصص المجدولة والمستحقة الآن للمعلم من النظامين (Gulf + Egyptian)
  /// حسب نافذة وقت بدء الحصة، واستخراج chatRoomId الخاص بكل حصة مستحقة.
  Future<void> loadScheduledLessons() async {
    final requestId = ++_scheduleRequestId;
    final dueLessons = <ScheduledLessonData>{};
    final dueClassroomIds = <String>{};
    final roomsFuture = chatRepo?.getChatRooms();

    // 1. الجدول الخليجي (Gulf Schedule)
    try {
      final gulfResult = await gulfScheduleRepo.getMyGulfSchedule();
      gulfResult.fold(
        (failure) {
          debugPrint(
            '[DEBUG StartSession] GulfSchedule load failure: ${failure.message}',
          );
        },
        (response) {
          final now = _nowIn(response.data.timezone);
          for (final classroom in response.data.classrooms) {
            for (final entry in classroom.entries) {
              final occurrenceDate = ScheduleTimeUtils.resolveOccurrenceDate(
                dayOrDate: entry.day,
                startTime: entry.startTime,
                endTime: entry.endTime,
                nowInTimezone: now,
              );
              final isDue = occurrenceDate != null;
              final cr = entry.chatRoomId ?? classroom.chatRoomId;
              final csId =
                  entry.classroomSubjectId ?? classroom.classroomSubjectId;

              debugPrint(
                '[DEBUG StartSession] Gulf Lesson -> '
                'classroomId: ${classroom.id}, '
                'classroomSubjectId: $csId, '
                'chatRoomId: $cr, '
                'day: ${entry.day}, '
                'startTime: ${entry.startTime}, '
                'endTime: ${entry.endTime}, '
                'now: $now, '
                'occurrenceDate: $occurrenceDate, '
                'isDue: $isDue',
              );

              if (isDue) {
                dueClassroomIds.add(classroom.id.trim());
                dueLessons.add(
                  ScheduledLessonData(
                    classroomId: classroom.id.trim(),
                    classroomSubjectId: csId?.trim(),
                    subjectId: classroom.subject?.id.trim(),
                    chatRoomId: cr?.trim(),
                    lessonId: null,
                    occurrenceDate: occurrenceDate,
                    occurrenceKey: entry.occurrenceKey?.trim(),
                    weeklySlotKey: entry.weeklySlotKey?.trim(),
                    startTime: entry.startTime,
                    endTime: entry.endTime,
                    day: entry.day,
                    system: 'gulf',
                  ),
                );
              }
            }
          }
        },
      );
    } catch (e) {
      debugPrint('[DEBUG StartSession] GulfSchedule error: $e');
    }

    // 2. الجدول المصري (Egyptian Schedule)
    try {
      final egyptResult = await tableManagementRepo
          .getMyEgyptianDigitalSchedule();
      egyptResult.fold(
        (failure) {
          debugPrint(
            '[DEBUG StartSession] EgyptianSchedule load failure: ${failure.message}',
          );
        },
        (week) {
          final now = _nowIn(week.timezone);
          for (final day in week.days) {
            for (final lesson in day.lessons) {
              final dayOrDate =
                  day.date.trim().isNotEmpty ? day.date : lesson.date;
              final occurrenceDate = ScheduleTimeUtils.resolveOccurrenceDate(
                dayOrDate: dayOrDate,
                startTime: lesson.startTime,
                endTime: lesson.endTime,
                nowInTimezone: now,
              );
              final isDue = occurrenceDate != null;
              final cr = lesson.chatRoomId;

              debugPrint(
                '[DEBUG StartSession] Egyptian Lesson -> '
                'classroomId: ${lesson.classroomId}, '
                'classroomSubjectId: ${lesson.classroomSubjectId}, '
                'chatRoomId: $cr, '
                'date: $dayOrDate, '
                'startTime: ${lesson.startTime}, '
                'endTime: ${lesson.endTime}, '
                'now: $now, '
                'occurrenceDate: $occurrenceDate, '
                'isDue: $isDue',
              );

              if (isDue) {
                dueClassroomIds.add(lesson.classroomId.trim());
                dueLessons.add(
                  ScheduledLessonData(
                    classroomId: lesson.classroomId.trim(),
                    classroomSubjectId: lesson.classroomSubjectId?.trim(),
                    subjectId: lesson.subjectId.trim(),
                    chatRoomId: cr?.trim(),
                    lessonId: lesson.id.trim(),
                    occurrenceDate: occurrenceDate,
                    weeklySlotKey:
                        lesson.activeSession?.weeklySlotKey?.trim(),
                    startTime: lesson.startTime,
                    endTime: lesson.endTime,
                    day: dayOrDate,
                    system: 'egyptian',
                  ),
                );
              }
            }
          }
        },
      );
    } catch (e) {
      debugPrint('[DEBUG StartSession] EgyptianSchedule error: $e');
    }

    final rooms = <ChatRoomSummaryModel>[];
    final pendingRooms = roomsFuture;
    if (pendingRooms != null) {
      final roomsResult = await pendingRooms;
      roomsResult.fold(
        (failure) => debugPrint(
          '[DEBUG StartSession] ChatRooms load failure: ${failure.message}',
        ),
        (response) => rooms.addAll(response.rooms),
      );
    }

    if (isClosed || requestId != _scheduleRequestId) return;
    _emitScheduledLessons(
      dueLessons: dueLessons,
      dueClassroomIds: dueClassroomIds,
      rooms: rooms,
    );
  }

  void _emitScheduledLessons({
    required Set<ScheduledLessonData> dueLessons,
    required Set<String> dueClassroomIds,
    required List<ChatRoomSummaryModel> rooms,
  }) {
    final chatRoomIds = <String>{};
    final dueByClassroom = <String, ScheduledLessonData>{};
    final dueByChatRoom = <String, ScheduledLessonData>{};

    for (final lesson in dueLessons) {
      dueByClassroom[lesson.classroomId] = lesson;
      final directRoomId = lesson.chatRoomId?.trim() ?? '';
      if (directRoomId.isNotEmpty) {
        chatRoomIds.add(directRoomId);
        dueByChatRoom[directRoomId] = lesson;
      }
      for (final room in rooms) {
        if (_matchesLesson(room, lesson)) {
          final rId = room.id.trim();
          chatRoomIds.add(rId);
          dueByChatRoom[rId] = lesson;
        }
      }
    }
    debugPrint(
      '[DEBUG StartSession] Final scheduledChatRoomIds: $chatRoomIds, '
      'dueClassroomIds: $dueClassroomIds',
    );
    if (!setEquals(state.scheduledChatRoomIds, chatRoomIds) ||
        !setEquals(state.scheduledClassroomIds, dueClassroomIds) ||
        !mapEquals(state.dueLessonsByClassroom, dueByClassroom) ||
        !mapEquals(state.dueLessonsByChatRoom, dueByChatRoom)) {
      emit(
        state.copyWith(
          scheduledChatRoomIds: chatRoomIds,
          scheduledClassroomIds: dueClassroomIds,
          dueLessonsByClassroom: dueByClassroom,
          dueLessonsByChatRoom: dueByChatRoom,
        ),
      );
    }
  }

  bool _matchesLesson(ChatRoomSummaryModel room, ScheduledLessonData lesson) {
    final roomId = room.id.trim();
    final classroomId = room.classroomId?.trim() ?? '';
    if (roomId.isEmpty || classroomId != lesson.classroomId) return false;
    final lessonSubject = lesson.classroomSubjectId?.trim() ?? '';
    final roomSubject = room.classroomSubjectId?.trim() ?? '';
    return lessonSubject.isEmpty ||
        roomSubject.isEmpty ||
        lessonSubject == roomSubject;
  }

  Future<void> loadActive(String classroomId) async {
    final classroom = classroomId.trim();
    if (classroom.isEmpty || state.isChecking(classroom)) return;
    final requestId = (_activeRequestIds[classroom] ?? 0) + 1;
    _activeRequestIds[classroom] = requestId;
    emit(
      state.copyWith(
        checkingClassroomIds: {...state.checkingClassroomIds, classroom},
      ),
    );
    final result = await repo.getActiveSession(classroomId: classroom);
    if (isClosed || _activeRequestIds[classroom] != requestId) return;
    final checking = {...state.checkingClassroomIds}..remove(classroom);
    result.fold(
      (failure) => emit(
        state.copyWith(
          checkingClassroomIds: checking,
          checkedClassroomIds: {...state.checkedClassroomIds, classroom},
          eventClassroomId: classroom,
          eventError: failure.message,
          eventCode: failure.code,
          eventStatusCode: failure.statusCode,
          eventId: state.eventId + 1,
        ),
      ),
      (data) {
        final active = {...state.activeByClassroom};
        final scheduledRooms = {...state.scheduledChatRoomIds};
        final scheduledClassrooms = {...state.scheduledClassroomIds};

        if (data == null ||
            (!data.session.isActive && !data.session.isScheduled)) {
          active.remove(classroom);
        } else {
          active[classroom] = data;
          if (data.session.isScheduled &&
              (data.session.isStartAvailable || data.session.isDueNow)) {
            scheduledClassrooms.add(classroom);
            final cr = data.session.chatRoomId.trim();
            if (cr.isNotEmpty) scheduledRooms.add(cr);
          }
        }
        emit(
          state.copyWith(
            checkingClassroomIds: checking,
            checkedClassroomIds: {...state.checkedClassroomIds, classroom},
            activeByClassroom: active,
            scheduledClassroomIds: scheduledClassrooms,
            scheduledChatRoomIds: scheduledRooms,
          ),
        );
      },
    );
  }

  static DateTime _nowIn(String? name) {
    final value = name?.trim();
    if (value == null || value.isEmpty) return DateTime.now();
    if (!_timezonesInitialized) {
      timezone_data.initializeTimeZones();
      _timezonesInitialized = true;
    }
    try {
      return timezone.TZDateTime.now(timezone.getLocation(value));
    } on timezone.LocationNotFoundException {
      return DateTime.now();
    }
  }

  Future<bool> start({
    required String classroomId,
    required String subjectId,
    String? classroomSubjectId,
    String? lessonId,
    String? occurrenceDate,
    String? system,
  }) async {
    final classroom = classroomId.trim();
    final subject = subjectId.trim();
    if (classroom.isEmpty) return _reject(StartSessionIssue.missingClassroom);
    if (subject.isEmpty) return _reject(StartSessionIssue.missingSubject);
    if (state.isLoading(classroom) ||
        state.active(classroom)?.session.isActive == true) {
      return false;
    }
    final requestId = (_requestIds[classroom] ?? 0) + 1;
    _requestIds[classroom] = requestId;
    emit(
      state.copyWith(
        loadingClassroomIds: {...state.loadingClassroomIds, classroom},
        eventClassroomId: null,
        eventError: null,
        eventCode: null,
        eventStatusCode: null,
        eventIssue: null,
        eventSuccess: false,
      ),
    );
    final result = await repo.startSession(
      classroomId: classroom,
      subjectId: subject,
      classroomSubjectId: classroomSubjectId,
      lessonId: lessonId,
      occurrenceDate: occurrenceDate,
      system: system,
    );
    if (!_isCurrent(classroom, requestId)) return false;
    final loading = {...state.loadingClassroomIds}..remove(classroom);
    var succeeded = false;
    var refreshActive = false;
    var refreshSchedule = false;
    result.fold(
      (failure) {
        final code = (failure.code ?? '').trim().toUpperCase();
        refreshActive =
            code == 'CLASSROOM_SESSION_ALREADY_ACTIVE' ||
            code == 'SESSION_NOT_ACTIVE' ||
            code == 'WEEKLY_ZOOM_SLOT_SESSION_NOT_ACTIVE' ||
            failure.statusCode == 404 ||
            failure.message.contains('CLASSROOM_SESSION_ALREADY_ACTIVE');
        refreshSchedule =
            code == 'SCHEDULE_OCCURRENCE_NOT_FOUND' ||
            code.startsWith('WEEKLY_ZOOM_ASSIGNMENT_');
        emit(
          state.copyWith(
            loadingClassroomIds: loading,
            eventClassroomId: classroom,
            eventError: failure.message,
            eventCode: failure.code,
            eventStatusCode: failure.statusCode,
            eventIssue: null,
            eventSuccess: false,
            eventId: state.eventId + 1,
          ),
        );
      },
      (data) {
        succeeded = true;
        emit(
          state.copyWith(
            loadingClassroomIds: loading,
            startedByClassroom: {...state.startedByClassroom, classroom: data},
            activeByClassroom: {...state.activeByClassroom, classroom: data},
            checkedClassroomIds: {...state.checkedClassroomIds, classroom},
            eventClassroomId: classroom,
            eventError: null,
            eventCode: null,
            eventStatusCode: null,
            eventIssue: null,
            eventSuccess: true,
            eventId: state.eventId + 1,
          ),
        );
      },
    );
    if (refreshActive || refreshSchedule) await loadActive(classroom);
    if (refreshSchedule) unawaited(loadScheduledLessons());
    return succeeded;
  }

  Future<String?> join(
    String classroomId, {
    String? weeklySlotKey,
  }) async {
    final classroom = classroomId.trim();
    if (isClosed || state.isLoading(classroom)) {
      return null;
    }
    if (classroom.isEmpty) {
      debugPrint('[DEBUG StartSession] join rejected: classroomId is empty');
      emit(
        state.copyWith(
          eventClassroomId: '',
          eventError: 'معرّف الفصل غير صالح',
          eventCode: 'INVALID_CLASSROOM_ID',
          eventId: state.eventId + 1,
        ),
      );
      return null;
    }
    debugPrint(
      '[DEBUG StartSession] join requested for classroomId: "$classroom"',
    );
    emit(
      state.copyWith(
        joiningClassroomIds: {...state.joiningClassroomIds, classroom},
        eventError: null,
        eventCode: null,
        eventStatusCode: null,
      ),
    );
    final result = await repo.joinActiveSession(
      classroomId: classroom,
      weeklySlotKey: weeklySlotKey,
    );
    if (isClosed) return null;
    final joining = {...state.joiningClassroomIds}..remove(classroom);
    String? link;
    var refreshActive = false;
    var refreshSchedule = false;
    result.fold(
      (failure) {
        debugPrint(
          '[DEBUG StartSession] join failure for classroomId="$classroom": '
          'message="${failure.message}", code="${failure.code}", statusCode=${failure.statusCode}',
        );
        final code = (failure.code ?? '').trim().toUpperCase();
        refreshActive =
            code == 'CLASSROOM_SESSION_ALREADY_ACTIVE' ||
            code == 'SESSION_NOT_ACTIVE' ||
            code == 'WEEKLY_ZOOM_SLOT_SESSION_NOT_ACTIVE' ||
            failure.statusCode == 404;
        refreshSchedule =
            code == 'SCHEDULE_OCCURRENCE_NOT_FOUND' ||
            code.startsWith('WEEKLY_ZOOM_ASSIGNMENT_');
        emit(
          state.copyWith(
            joiningClassroomIds: joining,
            eventClassroomId: classroom,
            eventError: failure.statusCode == 404
                ? 'SESSION_NOT_ACTIVE'
                : failure.message,
            eventCode: failure.code,
            eventStatusCode: failure.statusCode,
            eventId: state.eventId + 1,
          ),
        );
      },
      (value) {
        debugPrint(
          '[DEBUG StartSession] join succeeded for classroomId="$classroom", link="$value"',
        );
        link = value;
        emit(state.copyWith(joiningClassroomIds: joining));
      },
    );
    if (refreshActive || refreshSchedule) unawaited(loadActive(classroom));
    if (refreshSchedule) unawaited(loadScheduledLessons());
    return link;
  }

  Future<String?> getTeacherEntry({
    required String classroomId,
    required String sessionId,
  }) async {
    final classroom = classroomId.trim();
    final session = sessionId.trim();
    if (classroom.isEmpty || session.isEmpty) return null;
    if (isClosed || state.isLoading(classroom)) return null;
    emit(
      state.copyWith(
        loadingClassroomIds: {...state.loadingClassroomIds, classroom},
        eventError: null,
        eventCode: null,
      ),
    );
    final result = await repo.getTeacherEntry(
      classroomId: classroom,
      sessionId: session,
    );
    if (isClosed) return null;
    final loading = {...state.loadingClassroomIds}..remove(classroom);
    String? url;
    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingClassroomIds: loading,
          eventClassroomId: classroom,
          eventError: failure.message,
          eventCode: failure.code,
          eventStatusCode: failure.statusCode,
          eventId: state.eventId + 1,
        ),
      ),
      (link) {
        url = link;
        emit(state.copyWith(loadingClassroomIds: loading));
      },
    );
    return url;
  }

  Future<bool> end(String classroomId) async {
    final classroom = classroomId.trim();
    final session = state.active(classroom)?.session;
    final sessionId = session?.id.trim() ?? '';
    if (sessionId.isEmpty) {
      emit(
        state.copyWith(
          eventClassroomId: classroom,
          eventError: 'معرّف الجلسة غير صالح',
          eventCode: 'INVALID_SESSION_ID',
          eventId: state.eventId + 1,
        ),
      );
      return false;
    }
    if (state.isLoading(classroom)) return false;
    emit(
      state.copyWith(
        endingClassroomIds: {...state.endingClassroomIds, classroom},
      ),
    );
    final result = await repo.endSession(sessionId: sessionId);
    if (isClosed) return false;
    final ending = {...state.endingClassroomIds}..remove(classroom);
    var succeeded = false;
    result.fold(
      (failure) => emit(
        state.copyWith(
          endingClassroomIds: ending,
          eventError: failure.message,
          eventCode: failure.code,
          eventStatusCode: failure.statusCode,
          eventId: state.eventId + 1,
        ),
      ),
      (_) {
        succeeded = true;
        emit(state.copyWith(endingClassroomIds: ending));
      },
    );
    if (succeeded) await loadActive(classroom);
    return succeeded;
  }

  bool _reject(StartSessionIssue issue) {
    emit(
      state.copyWith(
        eventIssue: issue,
        eventError: null,
        eventSuccess: false,
        eventId: state.eventId + 1,
      ),
    );
    return false;
  }

  bool _isCurrent(String classroomId, int requestId) =>
      !isClosed && _requestIds[classroomId] == requestId;
}
