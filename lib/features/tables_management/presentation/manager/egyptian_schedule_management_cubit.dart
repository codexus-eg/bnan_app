import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/repo/egyptian_digital_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum EgyptianScheduleStatus { loading, ready, saving, failure }

class EgyptianScheduleState {
  const EgyptianScheduleState({
    this.status = EgyptianScheduleStatus.loading,
    this.days = const [],
    this.subjects = const [],
    this.selectedDay = 'sunday',
    this.error,
    this.actionError,
  });

  final EgyptianScheduleStatus status;
  final List<EgyptianScheduleDay> days;
  final List<EgyptianClassroomSubject> subjects;
  final String selectedDay;
  final String? error, actionError;

  EgyptianScheduleState copyWith({
    EgyptianScheduleStatus? status,
    List<EgyptianScheduleDay>? days,
    List<EgyptianClassroomSubject>? subjects,
    String? selectedDay,
    Object? error = _unset,
    Object? actionError = _unset,
  }) => EgyptianScheduleState(
    status: status ?? this.status,
    days: days ?? this.days,
    subjects: subjects ?? this.subjects,
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
    final schedule = await repo.getEgyptianClassroomWeek(classroomId);
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
    emit(
      state.copyWith(
        status: EgyptianScheduleStatus.ready,
        days: schedule.getOrElse(() => const EgyptianScheduleWeek()).days,
        subjects: subjects.getOrElse(() => const []),
        error: null,
        actionError: null,
      ),
    );
  }

  List<String> get addableDays => egyptianLessonDays;

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
    final dayKey = state.selectedDay;
    final day = _day(dayKey);
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
        'EDIT BLOCKED: original lesson not found; day=$dayKey '
        'lessonId=$originalLessonId availableDays='
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
    return _saveDay(dayKey, lessons, exists: day != null);
  }

  Future<bool> deleteLesson(String lessonId) async {
    if (state.status == EgyptianScheduleStatus.saving) {
      debugPrint('DELETE BLOCKED: already saving');
      return false;
    }
    final dayKey = state.selectedDay;
    final day = _day(dayKey);
    if (day == null) {
      debugPrint(
        'DELETE BLOCKED: day not found; day=$dayKey availableDays='
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
        ? await repo.deleteEgyptianDay(classroomId: classroomId, day: dayKey)
        : await repo.replaceEgyptianDay(
            classroomId: classroomId,
            request: EgyptianDayRequest(day: dayKey, lessons: remaining),
          );
    return _finish(result);
  }

  Future<bool> _saveDay(
    String day,
    List<EgyptianLessonRequest> lessons, {
    required bool exists,
  }) async {
    emit(
      state.copyWith(status: EgyptianScheduleStatus.saving, actionError: null),
    );
    final request = EgyptianDayRequest(day: day, lessons: lessons);
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

  EgyptianScheduleDay? _day(String dayName) {
    for (final day in state.days) {
      if (_dayName(day.date) == dayName) return day;
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

  Future<void> refreshSchedule() async {
    final result = await repo.getEgyptianClassroomWeek(classroomId);
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
}

String _dayName(String value) {
  final day = value.trim().toLowerCase();
  if (egyptianLessonDays.contains(day)) return day;
  return switch (DateTime.tryParse(value)?.weekday) {
    DateTime.saturday => 'saturday',
    DateTime.sunday => 'sunday',
    DateTime.monday => 'monday',
    DateTime.tuesday => 'tuesday',
    DateTime.wednesday => 'wednesday',
    DateTime.thursday => 'thursday',
    DateTime.friday => 'friday',
    _ => '',
  };
}

const _unset = Object();
