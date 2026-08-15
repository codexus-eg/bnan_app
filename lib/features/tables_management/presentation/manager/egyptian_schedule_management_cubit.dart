import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/repo/egyptian_digital_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:dartz/dartz.dart';
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
  static final _timePattern = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');

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
    final index = egyptianLessonDays.indexOf(day);
    return _selectedWeekStart().add(Duration(days: index < 0 ? 0 : index));
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
  }) async {
    if (state.status == EgyptianScheduleStatus.saving ||
        classroomSubjectId.isEmpty ||
        !_timePattern.hasMatch(startTime)) {
      return false;
    }
    final date = _dateForDay(_selectedWeekStart(), state.selectedDay);
    final day = _day(date);
    final lessons =
        day?.lessons
            .where((lesson) => lesson.id != originalLessonId)
            .map(_requestFromLesson)
            .toList() ??
        <EgyptianLessonRequest>[];
    if (lessons.any((item) => item.classroomSubjectId.isEmpty) ||
        lessons.any((item) => item.startTime == startTime)) {
      return false;
    }
    lessons.add(
      EgyptianLessonRequest(
        classroomSubjectId: classroomSubjectId,
        startTime: startTime,
      ),
    );
    return _saveDay(date, lessons, exists: day != null);
  }

  Future<bool> deleteLesson(String lessonId) async {
    if (state.status == EgyptianScheduleStatus.saving) return false;
    final date = _dateForDay(_selectedWeekStart(), state.selectedDay);
    final day = _day(date);
    if (day == null) return false;
    final remaining = day.lessons
        .where((lesson) => lesson.id != lessonId)
        .map(_requestFromLesson)
        .toList(growable: false);
    if (remaining.any((item) => item.classroomSubjectId.isEmpty)) return false;
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
    if (isClosed) return false;
    final failure = result.fold<Failure?>((value) => value, (_) => null);
    if (failure != null) {
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
    var classroomSubjectId = lesson.classroomSubjectId ?? '';
    if (classroomSubjectId.isEmpty) {
      for (final item in state.subjects) {
        if (item.subjectId == lesson.subjectId) {
          classroomSubjectId = item.classroomSubjectId;
        }
      }
    }
    return EgyptianLessonRequest(
      classroomSubjectId: classroomSubjectId,
      startTime: lesson.startTime,
    );
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

String _dateForDay(DateTime sunday, String day) {
  final index = egyptianLessonDays.indexOf(day);
  return _formatDate(sunday.add(Duration(days: index < 0 ? 0 : index)));
}

String _formatDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

const _unset = Object();
