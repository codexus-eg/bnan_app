import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';

enum GulfScheduleLoadStatus { initial, loading, ready, failure }

enum GulfScheduleAction { added, updated, deleted }

enum GulfScheduleIssue { missingClassroomSubject, duplicateDay, invalidData }

class GulfScheduleState {
  const GulfScheduleState({
    this.status = GulfScheduleLoadStatus.initial,
    this.classrooms = const [],
    this.selectedClassroomId,
    this.selectedDay = 'saturday',
    this.isSaving = false,
    this.isRefreshing = false,
    this.loadError,
    this.actionError,
    this.actionIssue,
    this.actionSuccess,
    this.eventId = 0,
  });

  final GulfScheduleLoadStatus status;
  final List<GulfClassroom> classrooms;
  final String? selectedClassroomId, loadError, actionError;
  final String selectedDay;
  final bool isSaving, isRefreshing;
  final GulfScheduleIssue? actionIssue;
  final GulfScheduleAction? actionSuccess;
  final int eventId;

  GulfClassroom? get selectedClassroom {
    for (final item in classrooms) {
      if (item.id == selectedClassroomId) return item;
    }
    return null;
  }

  GulfScheduleState copyWith({
    GulfScheduleLoadStatus? status,
    List<GulfClassroom>? classrooms,
    Object? classroomId = _unset,
    String? selectedDay,
    bool? isSaving,
    bool? isRefreshing,
    Object? loadError = _unset,
    Object? actionError = _unset,
    Object? actionIssue = _unset,
    Object? actionSuccess = _unset,
    int? eventId,
  }) => GulfScheduleState(
    status: status ?? this.status,
    classrooms: classrooms ?? this.classrooms,
    selectedClassroomId: classroomId == _unset
        ? selectedClassroomId
        : classroomId as String?,
    selectedDay: selectedDay ?? this.selectedDay,
    isSaving: isSaving ?? this.isSaving,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    loadError: loadError == _unset ? this.loadError : loadError as String?,
    actionError: actionError == _unset
        ? this.actionError
        : actionError as String?,
    actionIssue: actionIssue == _unset
        ? this.actionIssue
        : actionIssue as GulfScheduleIssue?,
    actionSuccess: actionSuccess == _unset
        ? this.actionSuccess
        : actionSuccess as GulfScheduleAction?,
    eventId: eventId ?? this.eventId,
  );
}

const _unset = Object();
