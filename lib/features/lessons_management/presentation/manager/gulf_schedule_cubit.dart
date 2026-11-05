import 'dart:async';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_payloads.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_slot.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_cubit.dart';
import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GulfScheduleCubit extends Cubit<GulfScheduleState> {
  GulfScheduleCubit(
    this.repo, {
    this.canManage = true,
    this.studentId,
    this.emptySuccessFallback = const [],
    this.initialClassId,
    AssignmentsRepo? assignmentsRepo,
    String? initialDay,
  })  : _assignmentsRepo = assignmentsRepo,
        super(GulfScheduleState(selectedDay: initialDay ?? _currentDayName));

  static String get _currentDayName => switch (DateTime.now().weekday) {
    DateTime.saturday => 'saturday',
    DateTime.sunday => 'sunday',
    DateTime.monday => 'monday',
    DateTime.tuesday => 'tuesday',
    DateTime.wednesday => 'wednesday',
    DateTime.thursday => 'thursday',
    DateTime.friday => 'friday',
    _ => 'saturday',
  };
  final GulfScheduleRepo repo;
  final bool canManage;
  final String? studentId;
  final List<GulfClassroom> emptySuccessFallback;
  final String? initialClassId;
  final AssignmentsRepo? _assignmentsRepo;
  int _loadGeneration = 0;
  static const _days = {
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  };
  Future<void> load({String? initialClassId}) =>
      _load(showLoading: true, initialClassId: initialClassId);

  Future<void> refresh({String? initialClassId}) {
    repo.invalidateScheduleCache();
    return _load(showLoading: false, initialClassId: initialClassId);
  }

  void selectClassroom(String? id) {
    if (id == null || !state.classrooms.any((item) => item.id == id)) return;
    emit(state.copyWith(classroomId: id));
    unawaited(ensureClassroomSubjectResolved(id));
    final classroom = state.classrooms.firstWhere((item) => item.id == id);
    if (classroom.isCourse) {
      unawaited(_loadCourseSchedule(classroom));
    }
  }

  void selectDay(String day) {
    if (day.isEmpty || day == state.selectedDay) return;
    emit(state.copyWith(selectedDay: day));
  }

  void clearActionFeedback() => emit(
    state.copyWith(actionError: null, actionIssue: null, actionSuccess: null),
  );

  Future<bool> saveEntry({
    String? originalDay,
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    if (!canManage) return false;
    final classroom = state.selectedClassroom;
    if (state.isSaving || classroom == null) return false;
    final isTeacher = SessionManager.instance.role == UserRole.teacher;
    final isEgyptian = classroom.curriculum?.registrationMode == 'egyptian';
    if (isTeacher && isEgyptian) return false;

    final entries = [...classroom.entries];
    if (!_days.contains(day) ||
        !ScheduleTimeUtils.isValid(startTime) ||
        !ScheduleTimeUtils.isValid(endTime) ||
        !ScheduleTimeUtils.isEndAfter(startTime, endTime)) {
      return _reject(GulfScheduleIssue.invalidData);
    }
    if (entries.any((item) => item.day == day && item.day != originalDay)) {
      return _reject(GulfScheduleIssue.duplicateDay);
    }
    if (classroom.isCourse) {
      return _saveCourseEntry(
        classroom: classroom,
        entries: entries,
        originalDay: originalDay,
        day: day,
        startTime: startTime,
        endTime: endTime,
      );
    }
    var classroomSubject = classroom.classroomSubjectId;
    if ((classroomSubject == null || classroomSubject.isEmpty) && isTeacher) {
      final assignRepo = _assignmentsRepo ?? getIt<AssignmentsRepo>();
      final assignedResult = await assignRepo.getTeacherAssignedSubjects(
        classroomId: classroom.id,
      );
      assignedResult.fold(
        (_) => null,
        (response) {
          final first = response.data.subjects.firstOrNull;
          if (first != null && first.classroomSubjectId.isNotEmpty) {
            classroomSubject = first.classroomSubjectId;
          }
        },
      );
    }
    final effectiveSubject = classroomSubject;
    if (effectiveSubject == null || effectiveSubject.isEmpty) {
      return _reject(GulfScheduleIssue.missingClassroomSubject);
    }
    final resolvedSubject = effectiveSubject;
    final newEntry = GulfScheduleEntry(
      id: '',
      day: day,
      startTime: startTime,
      endTime: endTime,
      classroomSubjectId: resolvedSubject,
      chatRoomId: classroom.chatRoomId,
    );
    final next = entries
        .where((item) => item.day != originalDay && item.day != day)
        .toList()
      ..add(newEntry);

    emit(_savingState());
    final request = GulfScheduleRequest(
      classroomSubject: resolvedSubject,
      schedule: next,
    );
    final result = await repo.updateClassroomSchedule(
      classroom.id,
      request,
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          isSaving: false,
          actionError: failure.message,
          eventId: state.eventId + 1,
        ));
        return false;
      },
      (_) {
        final updatedClassroom = classroom
            .copyWith(classroomSubject: resolvedSubject)
            .copyWithSchedule(
              GulfSchedule(
                id: classroom.schedule?.id ?? classroom.id,
                classroomSubject: resolvedSubject,
                entries: next,
                isActive: true,
              ),
            );
        final updatedClassrooms = state.classrooms
            .map((c) => c.id == classroom.id ? updatedClassroom : c)
            .toList();
        emit(state.copyWith(
          isSaving: false,
          classrooms: updatedClassrooms,
          selectedDay: day,
          actionSuccess: originalDay == null
              ? GulfScheduleAction.added
              : GulfScheduleAction.updated,
          eventId: state.eventId + 1,
        ));
        return true;
      },
    );
  }

  Future<bool> deleteSelectedDay() async {
    final day = state.selectedDay;
    if (day.isEmpty) return false;
    return deleteEntry(day);
  }

  Future<bool> deleteEntry(String day, {String? entryId}) async {
    if (!canManage) return false;
    final classroom = state.selectedClassroom;
    if (state.isSaving || classroom == null) {
      return false;
    }
    final isTeacher = SessionManager.instance.role == UserRole.teacher;
    final isEgyptian = classroom.curriculum?.registrationMode == 'egyptian';
    if (isTeacher && isEgyptian) return false;

    final targetDay = day.toLowerCase().trim();
    if (classroom.isCourse) {
      return _deleteCourseEntry(
        classroom: classroom,
        targetDay: targetDay,
        entryId: entryId,
      );
    }

    final next = classroom.entries
        .where((e) =>
            (entryId != null && entryId.isNotEmpty && e.id == entryId)
                ? false
                : (e.day.toLowerCase().trim() != targetDay))
        .toList();

    var classroomSubject = classroom.classroomSubjectId ??
        classroom.schedule?.classroomSubject;
    if ((classroomSubject == null || classroomSubject.isEmpty) && isTeacher) {
      final assignRepo = _assignmentsRepo ?? getIt<AssignmentsRepo>();
      final assignedResult = await assignRepo.getTeacherAssignedSubjects(
        classroomId: classroom.id,
      );
      assignedResult.fold(
        (_) => null,
        (response) {
          final first = response.data.subjects.firstOrNull;
          if (first != null && first.classroomSubjectId.isNotEmpty) {
            classroomSubject = first.classroomSubjectId;
          }
        },
      );
    }
    final effectiveSubject =
        classroomSubject ?? classroom.schedule?.classroomSubject ?? '';

    emit(_savingState());
    final request = GulfScheduleRequest(
      classroomSubject: effectiveSubject,
      schedule: next,
    );
    final result = await repo.updateClassroomSchedule(
      classroom.id,
      request,
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          isSaving: false,
          actionError: failure.message,
          eventId: state.eventId + 1,
        ));
        return false;
      },
      (_) {
        final updatedClassroom = classroom.copyWithSchedule(
          GulfSchedule(
            id: classroom.schedule?.id ?? classroom.id,
            classroomSubject: effectiveSubject,
            entries: next,
            isActive: true,
          ),
        );
        final updatedClassrooms = state.classrooms
            .map((c) => c.id == classroom.id ? updatedClassroom : c)
            .toList();
        emit(state.copyWith(
          isSaving: false,
          classrooms: updatedClassrooms,
          actionSuccess: GulfScheduleAction.deleted,
          eventId: state.eventId + 1,
        ));
        return true;
      },
    );
  }

  Future<void> _load({
    required bool showLoading,
    String? initialClassId,
  }) async {
    if (isClosed) return;
    final generation = ++_loadGeneration;
    if (showLoading) {
      emit(
        state.copyWith(
          status: GulfScheduleLoadStatus.loading,
          isRefreshing: false,
          loadError: null,
        ),
      );
    } else {
      emit(state.copyWith(isRefreshing: true, loadError: null));
    }
    final result = await repo.getMyGulfSchedule(studentId: studentId);
    if (isClosed || generation != _loadGeneration) return;
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: state.status == GulfScheduleLoadStatus.initial
              ? GulfScheduleLoadStatus.failure
              : (state.classrooms.isEmpty
                  ? GulfScheduleLoadStatus.failure
                  : state.status),
          isRefreshing: false,
          loadError: failure.message,
        ),
      ),
      (response) async {
        final realClassrooms = response.data.classrooms
            .where((item) {
              final mode = item.curriculum?.registrationMode;
              return mode == null || mode.isEmpty || mode == 'gulf';
            })
            .toList(growable: false);
        final classrooms = realClassrooms.isEmpty
            ? emptySuccessFallback
            : realClassrooms;
        final mergedClassrooms = [...classrooms];
        final target =
            initialClassId ?? this.initialClassId ?? state.selectedClassroomId;
        if (target != null &&
            target.isNotEmpty &&
            !mergedClassrooms.any((item) => item.id == target)) {
          final fallback = emptySuccessFallback.firstWhere(
            (item) => item.id == target,
            orElse: () => GulfClassroom(id: target, name: target),
          );
          mergedClassrooms.add(fallback);
        }
        final selected = mergedClassrooms.any((item) => item.id == target)
            ? target
            : mergedClassrooms.firstOrNull?.id;
        emit(
          state.copyWith(
            status: GulfScheduleLoadStatus.ready,
            classrooms: mergedClassrooms,
            classroomId: selected,
            isRefreshing: false,
            loadError: null,
          ),
        );
        if (selected != null) {
          unawaited(ensureClassroomSubjectResolved(selected));
          final selectedClassroom = mergedClassrooms.firstWhere(
            (c) => c.id == selected,
            orElse: () => const GulfClassroom(id: '', name: ''),
          );
          if (selectedClassroom.isCourse) {
            await _loadCourseSchedule(selectedClassroom);
          }
        }
      },
    );
  }

  Future<void> ensureClassroomSubjectResolved(String? classroomId) async {
    if (classroomId == null || classroomId.isEmpty) return;
    final isTeacher = SessionManager.instance.role == UserRole.teacher;
    if (!isTeacher) return;

    final classroom = state.classrooms.firstWhere(
      (c) => c.id == classroomId,
      orElse: () => const GulfClassroom(id: '', name: ''),
    );
    if (classroom.id.isEmpty) return;
    final hasSubject = classroom.subject != null &&
        classroom.subject!.name.trim().isNotEmpty;
    final hasSubjectId = classroom.classroomSubjectId != null &&
        classroom.classroomSubjectId!.isNotEmpty;
    if (hasSubject && hasSubjectId) return;

    final assignRepo = _assignmentsRepo ?? getIt<AssignmentsRepo>();
    final assignedResult = await assignRepo.getTeacherAssignedSubjects(
      classroomId: classroom.id,
    );
    if (isClosed) return;
    assignedResult.fold(
      (_) => null,
      (response) {
        final first = response.data.subjects.firstOrNull;
        if (first != null) {
          final resolvedSubjectId = first.classroomSubjectId.isNotEmpty
              ? first.classroomSubjectId
              : classroom.classroomSubjectId;
          final resolvedSubject = GulfSubject(
            id: first.id,
            name: first.name,
          );
          final updatedClassroom = classroom.copyWith(
            classroomSubject: resolvedSubjectId,
            subject: resolvedSubject,
          );
          final updatedClassrooms = state.classrooms
              .map((c) => c.id == classroom.id ? updatedClassroom : c)
              .toList();
          emit(state.copyWith(classrooms: updatedClassrooms));
        }
      },
    );
  }


  GulfScheduleState _savingState() => state.copyWith(
    isSaving: true,
    actionError: null,
    actionIssue: null,
    actionSuccess: null,
  );

  bool _reject(GulfScheduleIssue issue) {
    emit(state.copyWith(actionIssue: issue, eventId: state.eventId + 1));
    return false;
  }

  void _refreshZoomActiveSession(String classroomId) {
    if (getIt.isRegistered<StartSessionCubit>()) {
      unawaited(getIt<StartSessionCubit>().loadActive(classroomId));
    }
  }

  Future<void> _loadCourseSchedule(GulfClassroom classroom) async {
    final result = await repo.getCourseSchedule(classroom.id);
    if (isClosed) return;
    result.fold(
      (_) => null,
      (courseSchedule) {
        if (isClosed || courseSchedule.slots.isEmpty) return;
        final currentEntries = classroom.entries;
        final updatedEntries = courseSchedule.slots.map((s) {
          final matched = currentEntries.firstWhere(
            (e) => e.day.toLowerCase().trim() == s.day.toLowerCase().trim(),
            orElse: () => const GulfScheduleEntry(day: '', startTime: ''),
          );
          return GulfScheduleEntry(
            id: s.slotId ?? (matched.id?.isNotEmpty == true ? matched.id : null),
            slotId: s.slotId,
            day: s.day,
            startTime: s.startTime,
            endTime: s.endTime,
            classroomSubjectId: classroom.classroomSubjectId,
            chatRoomId: classroom.chatRoomId,
            classroomId: classroom.id,
            activeSession: matched.activeSession,
          );
        }).toList();

        final updatedClassroom = classroom.copyWithSchedule(
          GulfSchedule(
            id: classroom.schedule?.id ?? classroom.id,
            classroomSubject: classroom.classroomSubjectId ?? '',
            entries: updatedEntries,
            isActive: true,
          ),
        );
        final updatedClassrooms = state.classrooms
            .map((c) => c.id == classroom.id ? updatedClassroom : c)
            .toList();
        emit(state.copyWith(classrooms: updatedClassrooms));
      },
    );
  }

  Future<bool> _saveCourseEntry({
    required GulfClassroom classroom,
    required List<GulfScheduleEntry> entries,
    required String? originalDay,
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    emit(_savingState());
    final courseSlots = <CourseScheduleSlot>[];
    for (final item in entries) {
      if (item.day == originalDay) {
        courseSlots.add(
          CourseScheduleSlot(
            slotId: item.slotId ??
                (item.id?.startsWith('csl_') == true ? item.id : null),
            day: day,
            startTime: startTime,
            endTime: endTime,
          ),
        );
      } else if (item.day != day) {
        courseSlots.add(
          CourseScheduleSlot(
            slotId: item.slotId ??
                (item.id?.startsWith('csl_') == true ? item.id : null),
            day: item.day,
            startTime: item.startTime,
            endTime: item.endTime ?? '',
          ),
        );
      }
    }
    if (originalDay == null) {
      courseSlots.add(
        CourseScheduleSlot(
          day: day,
          startTime: startTime,
          endTime: endTime,
        ),
      );
    }

    final updateRequest = CourseScheduleUpdateRequest(
      timezone: 'Africa/Cairo',
      slots: courseSlots,
    );
    final result = await repo.updateCourseSchedule(
      classroom.id,
      updateRequest,
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          isSaving: false,
          actionError: failure.message,
          eventId: state.eventId + 1,
        ));
        return false;
      },
      (_) {
        final original = originalDay != null
            ? entries.firstWhere(
                (e) => e.day == originalDay,
                orElse: () => const GulfScheduleEntry(day: '', startTime: ''),
              )
            : null;
        final newEntry = GulfScheduleEntry(
          id: original?.id ?? '',
          slotId: original?.slotId,
          day: day,
          startTime: startTime,
          endTime: endTime,
          classroomSubjectId: classroom.classroomSubjectId,
          chatRoomId: classroom.chatRoomId,
          classroomId: classroom.id,
        );
        final next = entries
            .where((item) => item.day != originalDay && item.day != day)
            .toList()
          ..add(newEntry);
        final updatedClassroom = classroom.copyWithSchedule(
          GulfSchedule(
            id: classroom.schedule?.id ?? classroom.id,
            classroomSubject: classroom.classroomSubjectId ?? '',
            entries: next,
            isActive: true,
          ),
        );
        final updatedClassrooms = state.classrooms
            .map((c) => c.id == classroom.id ? updatedClassroom : c)
            .toList();
        emit(state.copyWith(
          isSaving: false,
          classrooms: updatedClassrooms,
          selectedDay: day,
          actionSuccess: originalDay == null
              ? GulfScheduleAction.added
              : GulfScheduleAction.updated,
          eventId: state.eventId + 1,
        ));
        _refreshZoomActiveSession(classroom.id);
        unawaited(_loadCourseSchedule(updatedClassroom));
        return true;
      },
    );
  }

  Future<bool> _deleteCourseEntry({
    required GulfClassroom classroom,
    required String targetDay,
    String? entryId,
  }) async {
    final targetEntry = classroom.entries.firstWhere(
      (e) =>
          (entryId != null &&
              entryId.isNotEmpty &&
              (e.slotId == entryId || e.id == entryId)) ||
          (e.day.toLowerCase().trim() == targetDay),
      orElse: () => const GulfScheduleEntry(day: '', startTime: ''),
    );

    String? slotId = targetEntry.slotId ??
        (targetEntry.id?.startsWith('csl_') == true
            ? targetEntry.id
            : (entryId?.startsWith('csl_') == true ? entryId : null));

    if (slotId == null || slotId.isEmpty) {
      final scheduleRes = await repo.getCourseSchedule(classroom.id);
      scheduleRes.fold((_) => null, (cs) {
        final matched = cs.slots.firstWhere(
          (s) => s.day.toLowerCase().trim() == targetDay,
          orElse: () =>
              const CourseScheduleSlot(day: '', startTime: '', endTime: ''),
        );
        if (matched.slotId != null && matched.slotId!.isNotEmpty) {
          slotId = matched.slotId;
        }
      });
    }

    slotId ??= (targetEntry.id?.isNotEmpty == true ? targetEntry.id : entryId);
    final resolvedSlotId = slotId;
    if (resolvedSlotId == null || resolvedSlotId.isEmpty) {
      return false;
    }

    emit(_savingState());
    final deleteResult = await repo.deleteCourseScheduleSlot(
      classroom.id,
      resolvedSlotId,
    );
    if (isClosed) return false;
    return deleteResult.fold(
      (failure) {
        emit(state.copyWith(
          isSaving: false,
          actionError: failure.message,
          eventId: state.eventId + 1,
        ));
        return false;
      },
      (_) {
        final next = classroom.entries
            .where((e) =>
                e.slotId != slotId &&
                e.id != slotId &&
                (entryId == null || e.id != entryId) &&
                e.day.toLowerCase().trim() != targetDay)
            .toList();
        final updatedClassroom = classroom.copyWithSchedule(
          GulfSchedule(
            id: classroom.schedule?.id ?? classroom.id,
            classroomSubject: classroom.classroomSubjectId ?? '',
            entries: next,
            isActive: true,
          ),
        );
        final updatedClassrooms = state.classrooms
            .map((c) => c.id == classroom.id ? updatedClassroom : c)
            .toList();
        emit(state.copyWith(
          isSaving: false,
          classrooms: updatedClassrooms,
          actionSuccess: GulfScheduleAction.deleted,
          eventId: state.eventId + 1,
        ));
        _refreshZoomActiveSession(classroom.id);
        return true;
      },
    );
  }
}
