import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/repo/egyptian_digital_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
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
        SessionManager.instance.role == UserRole.teacher ||
        classroomSubjectId.isEmpty ||
        !ScheduleTimeUtils.isValid(startTime) ||
        !ScheduleTimeUtils.isValid(endTime) ||
        !ScheduleTimeUtils.isEndAfter(startTime, endTime)) {
      debugPrint(
        'EDIT BLOCKED: status=${state.status} '
        'isTeacher=${SessionManager.instance.role == UserRole.teacher} '
        'classroomSubjectIdEmpty=${classroomSubjectId.isEmpty} '
        'validTimeRange='
        '${ScheduleTimeUtils.isEndAfter(startTime, endTime)}',
      );
      return false;
    }
    final dayKey = state.selectedDay;
    emit(state.copyWith(
      status: EgyptianScheduleStatus.saving,
      actionError: null,
    ));
    final entryInput = UnifiedScheduleEntryInput(
      day: dayKey,
      classroomSubjectId: classroomSubjectId,
      startTime: startTime,
      endTime: endTime,
    );
    final result = await repo.saveClassroomScheduleEntry(
      classroomId: classroomId,
      entry: entryInput,
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: EgyptianScheduleStatus.ready,
          actionError: failure.message,
        ));
        return false;
      },
      (mutation) {
        final subject = state.subjects.firstWhere(
          (s) => s.classroomSubjectId == classroomSubjectId,
          orElse: () => const EgyptianClassroomSubject(
            classroomSubjectId: '',
            subjectId: '',
            subjectName: '',
          ),
        );
        final newLesson = EgyptianDigitalLesson(
          id: mutation.id.isNotEmpty ? mutation.id : (originalLessonId ?? ''),
          date: dayKey,
          startTime: startTime,
          endTime: endTime,
          classroomId: classroomId,
          classroomName: '',
          subjectId: subject.subjectId,
          subjectName: subject.subjectName,
          classroomSubjectId: classroomSubjectId,
          teacherName: subject.teacherNames.join('، '),
          chatRoomId: subject.chatRoomId,
        );
        final updatedDays = state.days.map((day) {
          if (_dayName(day.date) != dayKey) return day;
          final lessons = day.lessons
              .where((l) => l.id != (originalLessonId ?? mutation.id))
              .toList()
            ..add(newLesson);
          return EgyptianScheduleDay(date: day.date, lessons: lessons);
        }).toList();
        if (!updatedDays.any((d) => _dayName(d.date) == dayKey)) {
          updatedDays.add(
            EgyptianScheduleDay(date: dayKey, lessons: [newLesson]),
          );
        }
        emit(state.copyWith(
          status: EgyptianScheduleStatus.ready,
          days: updatedDays,
          actionError: null,
        ));
        return true;
      },
    );
  }

  Future<bool> deleteLesson(String lessonId) async {
    if (state.status == EgyptianScheduleStatus.saving ||
        SessionManager.instance.role == UserRole.teacher) {
      debugPrint('DELETE BLOCKED: already saving or teacher');
      return false;
    }
    emit(
      state.copyWith(status: EgyptianScheduleStatus.saving, actionError: null),
    );
    final result = await repo.deleteClassroomScheduleEntry(
      classroomId: classroomId,
      entryId: lessonId,
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: EgyptianScheduleStatus.ready,
          actionError: failure.message,
        ));
        return false;
      },
      (_) {
        final updatedDays = state.days.map((day) {
          final lessons = day.lessons.where((l) => l.id != lessonId).toList();
          return EgyptianScheduleDay(date: day.date, lessons: lessons);
        }).toList();
        emit(state.copyWith(
          status: EgyptianScheduleStatus.ready,
          days: updatedDays,
          actionError: null,
        ));
        return true;
      },
    );
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
