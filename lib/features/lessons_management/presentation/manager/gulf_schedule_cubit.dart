import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GulfScheduleCubit extends Cubit<GulfScheduleState> {
  GulfScheduleCubit(this.repo) : super(const GulfScheduleState());
  final GulfScheduleRepo repo;
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
  static final _timePattern = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');

  Future<void> load() => _load(showLoading: true);

  void selectClassroom(String? id) {
    if (id == null || !state.classrooms.any((item) => item.id == id)) return;
    emit(state.copyWith(classroomId: id));
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
  }) async {
    final classroom = state.selectedClassroom;
    if (state.isSaving || classroom == null) return false;
    final entries = [...classroom.entries];
    if (!_days.contains(day) || !_timePattern.hasMatch(startTime)) {
      return _reject(GulfScheduleIssue.invalidData);
    }
    if (entries.any((item) => item.day == day && item.day != originalDay)) {
      return _reject(GulfScheduleIssue.duplicateDay);
    }
    final classroomSubject = classroom.classroomSubjectId;
    if (classroomSubject == null) {
      return _reject(GulfScheduleIssue.missingClassroomSubject);
    }
    final next = entries.where((item) => item.day != originalDay).toList()
      ..add(GulfScheduleEntry(day: day, startTime: startTime));
    return _mutate(
      classroom: classroom,
      request: GulfScheduleRequest(
        classroomSubject: classroomSubject,
        schedule: next,
      ),
      action: originalDay == null
          ? GulfScheduleAction.added
          : GulfScheduleAction.updated,
      selectedDay: day,
      create: classroom.schedule == null,
    );
  }

  Future<bool> deleteEntry(String day) async {
    final classroom = state.selectedClassroom;
    if (state.isSaving || classroom == null || classroom.schedule == null) {
      return false;
    }
    final remaining = classroom.entries
        .where((item) => item.day != day)
        .toList(growable: false);
    final classroomSubject = classroom.classroomSubjectId;
    if (remaining.isNotEmpty && classroomSubject == null) {
      return _reject(GulfScheduleIssue.missingClassroomSubject);
    }
    emit(_savingState());
    final result = remaining.isEmpty
        ? await repo.deleteClassroomSchedule(classroom.id)
        : await repo.updateClassroomSchedule(
            classroom.id,
            GulfScheduleRequest(
              classroomSubject: classroomSubject!,
              schedule: remaining,
            ),
          );
    return _finish(
      result.fold((failure) => failure.message, (_) => null),
      GulfScheduleAction.deleted,
    );
  }

  Future<void> _load({required bool showLoading}) async {
    final generation = ++_loadGeneration;
    if (showLoading) {
      emit(
        state.copyWith(status: GulfScheduleLoadStatus.loading, loadError: null),
      );
    }
    final result = await repo.getMyGulfSchedule();
    if (isClosed || generation != _loadGeneration) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GulfScheduleLoadStatus.failure,
          loadError: failure.message,
        ),
      ),
      (response) {
        final classrooms = response.data.classrooms;
        final previous = state.selectedClassroomId;
        final selected = classrooms.any((item) => item.id == previous)
            ? previous
            : classrooms.firstOrNull?.id;
        emit(
          state.copyWith(
            status: GulfScheduleLoadStatus.ready,
            classrooms: classrooms,
            classroomId: selected,
            loadError: null,
          ),
        );
      },
    );
  }

  Future<bool> _mutate({
    required GulfClassroom classroom,
    required GulfScheduleRequest request,
    required GulfScheduleAction action,
    required String selectedDay,
    required bool create,
  }) async {
    emit(_savingState());
    final result = create
        ? await repo.createClassroomSchedule(classroom.id, request)
        : await repo.updateClassroomSchedule(classroom.id, request);
    if (isClosed) return false;
    emit(state.copyWith(selectedDay: selectedDay));
    return _finish(
      result.fold((failure) => failure.message, (_) => null),
      action,
    );
  }

  Future<bool> _finish(String? error, GulfScheduleAction action) async {
    if (isClosed) return false;
    await _load(showLoading: false);
    if (isClosed) return false;
    if (error != null) {
      emit(
        state.copyWith(
          isSaving: false,
          actionError: error,
          eventId: state.eventId + 1,
        ),
      );
      return false;
    }
    emit(
      state.copyWith(
        isSaving: false,
        actionSuccess: action,
        eventId: state.eventId + 1,
      ),
    );
    return true;
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
}
