import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/repo/egyptian_digital_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum EgyptianScheduleStatus { loading, ready, saving, failure }

class EgyptianWeekOption {
  const EgyptianWeekOption({required this.number, required this.weekStart});

  final int number;
  final DateTime weekStart;
}

class EgyptianScheduleState {
  const EgyptianScheduleState({
    this.status = EgyptianScheduleStatus.loading,
    this.days = const [],
    this.subjects = const [],
    this.availableWeeks = const [],
    this.selectedWeek,
    this.currentWeek,
    this.selectedDay = 'sunday',
    this.error,
    this.actionError,
  });

  final EgyptianScheduleStatus status;
  final List<EgyptianScheduleDay> days;
  final List<EgyptianClassroomSubject> subjects;
  final List<EgyptianWeekOption> availableWeeks;
  final int? selectedWeek, currentWeek;
  final String selectedDay;
  final String? error, actionError;

  EgyptianScheduleState copyWith({
    EgyptianScheduleStatus? status,
    List<EgyptianScheduleDay>? days,
    List<EgyptianClassroomSubject>? subjects,
    List<EgyptianWeekOption>? availableWeeks,
    Object? selectedWeek = _unset,
    Object? currentWeek = _unset,
    String? selectedDay,
    Object? error = _unset,
    Object? actionError = _unset,
  }) => EgyptianScheduleState(
    status: status ?? this.status,
    days: days ?? this.days,
    subjects: subjects ?? this.subjects,
    availableWeeks: availableWeeks ?? this.availableWeeks,
    selectedWeek: selectedWeek == _unset
        ? this.selectedWeek
        : selectedWeek as int?,
    currentWeek: currentWeek == _unset ? this.currentWeek : currentWeek as int?,
    selectedDay: selectedDay ?? this.selectedDay,
    error: error == _unset ? this.error : error as String?,
    actionError: actionError == _unset
        ? this.actionError
        : actionError as String?,
  );
}

class EgyptianScheduleManagementCubit extends Cubit<EgyptianScheduleState> {
  EgyptianScheduleManagementCubit({
    required this.repo,
    required this.classroomId,
  }) : super(const EgyptianScheduleState());

  final EgyptianDigitalScheduleRepo repo;
  final String classroomId;

  Future<void> load() async {
    emit(state.copyWith(status: EgyptianScheduleStatus.loading, error: null));
    final subjects = await repo.getEgyptianClassroomSubjects(classroomId);
    final initialWeekStart = _formatDate(_weekStart(_cairoNow()));
    final schedule = await repo.getEgyptianClassroomWeek(
      classroomId,
      weekStart: initialWeekStart,
    );
    if (isClosed) return;
    final error =
        subjects.fold((failure) => failure.message, (_) => null) ??
        schedule.fold((failure) => failure.message, (_) => null);
    if (error != null) {
      emit(
        state.copyWith(status: EgyptianScheduleStatus.failure, error: error),
      );
      return;
    }
    var week = schedule.getOrElse(() => const EgyptianScheduleWeek());
    final backendWeekStart = week.currentWeekStart;
    if (backendWeekStart != null &&
        _formatDate(backendWeekStart) != initialWeekStart) {
      final currentSchedule = await repo.getEgyptianClassroomWeek(
        classroomId,
        weekStart: _formatDate(backendWeekStart),
      );
      if (isClosed) return;
      final refreshFailure = currentSchedule.fold<Failure?>(
        (failure) => failure,
        (_) => null,
      );
      if (refreshFailure != null) {
        emit(
          state.copyWith(
            status: EgyptianScheduleStatus.failure,
            error: refreshFailure.message,
          ),
        );
        return;
      }
      final currentWeek = currentSchedule.getOrElse(
        () => const EgyptianScheduleWeek(),
      );
      week = EgyptianScheduleWeek(
        days: currentWeek.days,
        currentWeek: week.currentWeek,
        currentWeekStart: backendWeekStart,
        timezone: week.timezone,
      );
    }
    final loaded = _weekState(week);
    emit(
      loaded.copyWith(
        subjects: subjects.getOrElse(() => const []),
        error: null,
        actionError: null,
      ),
    );
  }

  Future<void> selectWeek(int? number) async {
    if (number == null || number == state.selectedWeek) return;
    final option = state.availableWeeks
        .where((item) => item.number == number)
        .firstOrNull;
    if (option == null) return;
    emit(
      state.copyWith(
        status: EgyptianScheduleStatus.loading,
        selectedWeek: number,
      ),
    );
    final result = await repo.getEgyptianClassroomWeek(
      classroomId,
      weekStart: _formatDate(option.weekStart),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EgyptianScheduleStatus.failure,
          error: failure.message,
        ),
      ),
      (week) => emit(
        state.copyWith(
          status: EgyptianScheduleStatus.ready,
          days: week.days,
          selectedWeek: number,
          error: null,
        ),
      ),
    );
  }

  bool get isPreviousWeek =>
      state.selectedWeek != null &&
      state.currentWeek != null &&
      state.selectedWeek! < state.currentWeek!;

  List<String> get addableDays {
    if (state.selectedWeek == null || state.currentWeek == null) {
      return const [];
    }
    if (state.selectedWeek! > state.currentWeek!) return egyptianLessonDays;
    final today = _dateOnly(_cairoNow());
    return egyptianLessonDays
        .where((day) => !selectedDate(day).isBefore(today))
        .toList(growable: false);
  }

  bool isPastStart(String day, String time) {
    final date = selectedDate(day);
    final today = _dateOnly(_cairoNow());
    if (date.isBefore(today)) return true;
    if (date.isAfter(today)) return false;
    final parts = time.split(':');
    if (parts.length != 2) return false;
    final now = _cairoNow();
    final value = DateTime(
      now.year,
      now.month,
      now.day,
      int.tryParse(parts[0]) ?? 0,
      int.tryParse(parts[1]) ?? 0,
    );
    return !value.isAfter(now);
  }

  DateTime selectedDate(String day) {
    return _dateForDayValue(_selectedWeekStart(), day);
  }

  void selectDay(String day) {
    if (!egyptianLessonDays.contains(day)) return;
    emit(state.copyWith(selectedDay: day));
  }

  void clearActionError() {
    if (state.actionError != null) emit(state.copyWith(actionError: null));
  }

  Future<bool> saveLesson({
    String? originalLessonId,
    required String classroomSubjectId,
    required String startTime,
    required String endTime,
  }) async {
    if (state.status == EgyptianScheduleStatus.saving ||
        classroomSubjectId.isEmpty ||
        !ScheduleTimeUtils.isValid(startTime) ||
        !ScheduleTimeUtils.isValid(endTime) ||
        !ScheduleTimeUtils.isEndAfter(startTime, endTime)) {
      debugPrint(
        'EDIT BLOCKED: status=${state.status} '
        'classroomSubjectIdEmpty=${classroomSubjectId.isEmpty} '
        'validTimeRange='
        '${ScheduleTimeUtils.isEndAfter(startTime, endTime)}',
      );
      return false;
    }
    final date = _dateForDay(_selectedWeekStart(), state.selectedDay);
    final day = _day(date);
    final updatedLesson = EgyptianLessonRequest(
      classroomSubjectId: classroomSubjectId,
      startTime: startTime,
      endTime: endTime,
    );
    final lessons = <EgyptianLessonRequest>[];
    var replaced = false;
    for (final lesson in day?.lessons ?? const <EgyptianDigitalLesson>[]) {
      if (!replaced &&
          originalLessonId != null &&
          lesson.id == originalLessonId) {
        lessons.add(updatedLesson);
        replaced = true;
      } else {
        lessons.add(_requestFromLesson(lesson));
      }
    }
    if (originalLessonId != null && !replaced) {
      debugPrint(
        'EDIT BLOCKED: original lesson not found; date=$date '
        'lessonId=$originalLessonId availableDates='
        '${state.days.map((item) => item.date).toList()}',
      );
      return false;
    }
    if (originalLessonId == null) lessons.add(updatedLesson);
    if (lessons.any((item) => item.classroomSubjectId.isEmpty) ||
        _hasDuplicateStartTime(lessons)) {
      debugPrint(
        'EDIT BLOCKED: invalid classroomSubjectId or duplicate startTime',
      );
      return false;
    }
    return _saveDay(date, lessons, exists: day != null);
  }

  Future<bool> deleteLesson(String lessonId) async {
    if (state.status == EgyptianScheduleStatus.saving) {
      debugPrint('DELETE BLOCKED: already saving');
      return false;
    }
    final date = _dateForDay(_selectedWeekStart(), state.selectedDay);
    final day = _day(date);
    if (day == null) {
      debugPrint(
        'DELETE BLOCKED: day not found; date=$date availableDates='
        '${state.days.map((item) => item.date).toList()}',
      );
      return false;
    }
    final remaining = <EgyptianLessonRequest>[];
    var removed = false;
    for (final lesson in day.lessons) {
      if (!removed && lesson.id == lessonId) {
        removed = true;
      } else {
        remaining.add(_requestFromLesson(lesson));
      }
    }
    if (!removed) {
      debugPrint(
        'DELETE BLOCKED: lesson not found; lessonId=$lessonId '
        'availableIds=${day.lessons.map((item) => item.id).toList()}',
      );
      return false;
    }
    if (remaining.any((item) => item.classroomSubjectId.isEmpty)) {
      debugPrint('DELETE BLOCKED: remaining classroomSubjectId is empty');
      return false;
    }
    emit(
      state.copyWith(status: EgyptianScheduleStatus.saving, actionError: null),
    );
    final result = remaining.isEmpty
        ? await repo.deleteEgyptianDay(classroomId: classroomId, date: date)
        : await repo.replaceEgyptianDay(
            classroomId: classroomId,
            request: EgyptianDayRequest(date: date, lessons: remaining),
          );
    return _finish(result);
  }

  Future<bool> _saveDay(
    String date,
    List<EgyptianLessonRequest> lessons, {
    required bool exists,
  }) async {
    emit(
      state.copyWith(status: EgyptianScheduleStatus.saving, actionError: null),
    );
    final request = EgyptianDayRequest(date: date, lessons: lessons);
    final result = exists
        ? await repo.replaceEgyptianDay(
            classroomId: classroomId,
            request: request,
          )
        : await repo.createEgyptianDay(
            classroomId: classroomId,
            request: request,
          );
    return _finish(result);
  }

  Future<bool> _finish(Either<Failure, void> result) async {
    if (isClosed) {
      debugPrint('SCHEDULE ACTION BLOCKED: cubit is closed');
      return false;
    }
    final failure = result.fold<Failure?>((value) => value, (_) => null);
    if (failure != null) {
      debugPrint(
        'SCHEDULE ACTION FAILED: code=${failure.code} '
        'message=${failure.message}',
      );
      emit(
        state.copyWith(
          status: EgyptianScheduleStatus.ready,
          actionError: failure.message,
        ),
      );
      return false;
    }
    emit(
      state.copyWith(status: EgyptianScheduleStatus.ready, actionError: null),
    );
    return true;
  }

  EgyptianScheduleDay? _day(String date) {
    for (final day in state.days) {
      if (day.date == date) return day;
    }
    return null;
  }

  EgyptianLessonRequest _requestFromLesson(EgyptianDigitalLesson lesson) {
    return EgyptianLessonRequest(
      classroomSubjectId: lesson.classroomSubjectId ?? '',
      startTime: lesson.startTime,
      endTime: lesson.endTime,
    );
  }

  bool _hasDuplicateStartTime(List<EgyptianLessonRequest> lessons) {
    final times = <String>{};
    return lessons.any((lesson) => !times.add(lesson.startTime));
  }

  Future<void> refreshSelectedWeek() async {
    final result = await repo.getEgyptianClassroomWeek(
      classroomId,
      weekStart: _formatDate(_selectedWeekStart()),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: EgyptianScheduleStatus.ready,
            actionError: failure.message,
          ),
        );
      },
      (week) {
        emit(
          state.copyWith(
            status: EgyptianScheduleStatus.ready,
            days: week.days,
            actionError: null,
          ),
        );
      },
    );
  }

  EgyptianScheduleState _weekState(EgyptianScheduleWeek week) {
    final current = week.currentWeek;
    final currentStart = week.currentWeekStart;
    if (current == null || currentStart == null || current < 1) {
      return state.copyWith(
        status: EgyptianScheduleStatus.ready,
        days: week.days,
        availableWeeks: const [],
        selectedWeek: null,
        currentWeek: null,
      );
    }
    final weekOne = _dateOnly(
      currentStart.subtract(Duration(days: (current - 1) * 7)),
    );
    final now = _cairoNow();
    final count =
        current +
        (now.weekday == DateTime.friday || now.weekday == DateTime.saturday
            ? 1
            : 0);
    return state.copyWith(
      status: EgyptianScheduleStatus.ready,
      days: week.days,
      availableWeeks: List.generate(
        count,
        (index) => EgyptianWeekOption(
          number: index + 1,
          weekStart: weekOne.add(Duration(days: index * 7)),
        ),
      ),
      selectedWeek: current,
      currentWeek: current,
    );
  }

  DateTime _selectedWeekStart() =>
      state.availableWeeks
          .where((item) => item.number == state.selectedWeek)
          .map((item) => item.weekStart)
          .firstOrNull ??
      _weekStart(_cairoNow());
}

DateTime _weekStart(DateTime now) {
  return DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: now.weekday % 7));
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _cairoNow([DateTime? value]) {
  final utc = (value ?? DateTime.now()).toUtc();
  final shifted = utc.add(Duration(hours: _cairoDst(utc) ? 3 : 2));
  return DateTime(
    shifted.year,
    shifted.month,
    shifted.day,
    shifted.hour,
    shifted.minute,
    shifted.second,
  );
}

bool _cairoDst(DateTime utc) {
  final start = _lastWeekday(
    utc.year,
    DateTime.april,
    DateTime.friday,
  ).subtract(const Duration(hours: 2));
  final end = _lastWeekday(
    utc.year,
    DateTime.october,
    DateTime.thursday,
  ).add(const Duration(hours: 21));
  return !utc.isBefore(start) && utc.isBefore(end);
}

DateTime _lastWeekday(int year, int month, int weekday) {
  var value = DateTime.utc(year, month + 1, 0);
  while (value.weekday != weekday) {
    value = value.subtract(const Duration(days: 1));
  }
  return value;
}

String _dateForDay(DateTime weekStart, String day) =>
    _formatDate(_dateForDayValue(weekStart, day));

DateTime _dateForDayValue(DateTime weekStart, String day) {
  final targetWeekday = switch (day) {
    'sunday' => DateTime.sunday,
    'monday' => DateTime.monday,
    'tuesday' => DateTime.tuesday,
    'wednesday' => DateTime.wednesday,
    'thursday' => DateTime.thursday,
    _ => weekStart.weekday,
  };
  final offset = (targetWeekday - weekStart.weekday + 7) % 7;
  return _dateOnly(weekStart).add(Duration(days: offset));
}

String _formatDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

const _unset = Object();
