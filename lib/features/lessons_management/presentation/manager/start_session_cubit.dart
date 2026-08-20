import 'package:bnan_app/core/utils/schedule_time_utils.dart';
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
    this.tableManagementRepo,
  ) : super(const StartSessionState());
  final StartSessionRepo repo;
  final GulfScheduleRepo gulfScheduleRepo;
  final TableManagementRepo tableManagementRepo;
  final Map<String, int> _requestIds = {};
  final Map<String, int> _activeRequestIds = {};
  static bool _timezonesInitialized = false;

  /// جلب الحصص المجدولة والمستحقة الآن للمعلم من النظامين (Gulf + Egyptian)
  /// حسب نافذة وقت بدء الحصة، واستخراج chatRoomId الخاص بكل حصة مستحقة.
  Future<void> loadScheduledLessons() async {
    final chatRoomIds = <String>{};

    // 1. الجدول الخليجي (Gulf Schedule)
    try {
      final gulfResult = await gulfScheduleRepo.getMyGulfSchedule();
      gulfResult.fold((failure) {
        debugPrint('[DEBUG StartSession] GulfSchedule load failure: ${failure.message}');
      }, (response) {
        final now = _nowIn(response.data.timezone);
        final todayName = _weekdayName(now.weekday);
        for (final classroom in response.data.classrooms) {
          for (final entry in classroom.entries) {
            final isDayMatch = entry.day.trim().toLowerCase() == todayName;
            final isDue = ScheduleTimeUtils.isDueNow(
              entry.startTime,
              entry.endTime,
              now: now,
            );
            final cr = entry.chatRoomId ?? classroom.chatRoomId;
            final csId = entry.classroomSubjectId ?? classroom.classroomSubjectId;

            debugPrint(
              '[DEBUG StartSession] Gulf Lesson -> '
              'classroomId: ${classroom.id}, '
              'classroomSubjectId: $csId, '
              'chatRoomId: $cr, '
              'day: ${entry.day} (today: $todayName -> match: $isDayMatch), '
              'startTime: ${entry.startTime}, '
              'endTime: ${entry.endTime}, '
              'now: $now, '
              'isDueNow: $isDue',
            );

            if (isDayMatch && isDue && cr != null && cr.isNotEmpty) {
              chatRoomIds.add(cr);
            }
          }
        }
      });
    } catch (e) {
      debugPrint('[DEBUG StartSession] GulfSchedule error: $e');
    }

    // 2. الجدول المصري (Egyptian Schedule)
    try {
      final egyptResult =
          await tableManagementRepo.getMyEgyptianDigitalSchedule();
      egyptResult.fold((failure) {
        debugPrint('[DEBUG StartSession] EgyptianSchedule load failure: ${failure.message}');
      }, (week) {
        final now = _nowIn(week.timezone);
        final todayName = _weekdayName(now.weekday);
        final todayIso = now.toIso8601String().split('T').first;
        for (final day in week.days) {
          final dayLower = day.date.trim().toLowerCase();
          final isDayMatch = dayLower == todayName ||
              dayLower == todayIso ||
              _dayKey(day.date) == todayName;
          for (final lesson in day.lessons) {
            final isDue = ScheduleTimeUtils.isDueNow(
              lesson.startTime,
              lesson.endTime,
              now: now,
            );
            final cr = lesson.chatRoomId;

            debugPrint(
              '[DEBUG StartSession] Egyptian Lesson -> '
              'classroomId: ${lesson.classroomId}, '
              'classroomSubjectId: ${lesson.classroomSubjectId}, '
              'chatRoomId: $cr, '
              'date: ${day.date} (today: $todayName -> match: $isDayMatch), '
              'startTime: ${lesson.startTime}, '
              'endTime: ${lesson.endTime}, '
              'now: $now, '
              'isDueNow: $isDue',
            );

            if (isDayMatch && isDue && cr != null && cr.isNotEmpty) {
              chatRoomIds.add(cr);
            }
          }
        }
      });
    } catch (e) {
      debugPrint('[DEBUG StartSession] EgyptianSchedule error: $e');
    }

    debugPrint('[DEBUG StartSession] Final scheduledChatRoomIds: $chatRoomIds');

    if (!isClosed) {
      emit(state.copyWith(scheduledChatRoomIds: chatRoomIds));
    }
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
        if (data == null || !data.session.isActive) {
          active.remove(classroom);
        } else {
          active[classroom] = data;
        }
        emit(
          state.copyWith(
            checkingClassroomIds: checking,
            checkedClassroomIds: {...state.checkedClassroomIds, classroom},
            activeByClassroom: active,
          ),
        );
      },
    );
  }

  static String _weekdayName(int weekday) => switch (weekday) {
    DateTime.saturday => 'saturday',
    DateTime.sunday => 'sunday',
    DateTime.monday => 'monday',
    DateTime.tuesday => 'tuesday',
    DateTime.wednesday => 'wednesday',
    DateTime.thursday => 'thursday',
    DateTime.friday => 'friday',
    _ => '',
  };

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

  static String? _dayKey(String value) {
    final day = value.trim().toLowerCase();
    const validDays = [
      'saturday',
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
    ];
    if (validDays.contains(day)) return day;
    return switch (DateTime.tryParse(value)?.weekday) {
      DateTime.saturday => 'saturday',
      DateTime.sunday => 'sunday',
      DateTime.monday => 'monday',
      DateTime.tuesday => 'tuesday',
      DateTime.wednesday => 'wednesday',
      DateTime.thursday => 'thursday',
      DateTime.friday => 'friday',
      _ => null,
    };
  }

  Future<bool> start({
    required String classroomId,
    required String subjectId,
  }) async {
    final classroom = classroomId.trim();
    final subject = subjectId.trim();
    if (classroom.isEmpty) return _reject(StartSessionIssue.missingClassroom);
    if (subject.isEmpty) return _reject(StartSessionIssue.missingSubject);
    if (state.isLoading(classroom) || state.active(classroom) != null) {
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
    );
    if (!_isCurrent(classroom, requestId)) return false;
    final loading = {...state.loadingClassroomIds}..remove(classroom);
    var succeeded = false;
    var refreshActive = false;
    result.fold(
      (failure) {
        refreshActive =
            failure.code == 'CLASSROOM_SESSION_ALREADY_ACTIVE' ||
            failure.message.contains('CLASSROOM_SESSION_ALREADY_ACTIVE');
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
    if (refreshActive) await loadActive(classroom);
    return succeeded;
  }

  Future<String?> join(String classroomId) async {
    final classroom = classroomId.trim();
    if (isClosed || classroom.isEmpty || state.isLoading(classroom)) {
      return null;
    }
    emit(
      state.copyWith(
        joiningClassroomIds: {...state.joiningClassroomIds, classroom},
        eventError: null,
        eventCode: null,
        eventStatusCode: null,
      ),
    );
    final result = await repo.joinActiveSession(classroomId: classroom);
    if (isClosed) return null;
    final joining = {...state.joiningClassroomIds}..remove(classroom);
    String? link;
    result.fold(
      (failure) => emit(
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
      ),
      (value) {
        link = value;
        emit(state.copyWith(joiningClassroomIds: joining));
      },
    );
    return link;
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
