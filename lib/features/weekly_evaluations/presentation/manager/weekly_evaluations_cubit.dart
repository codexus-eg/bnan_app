import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyEvaluationsCubit extends Cubit<WeeklyEvaluationsState> {
  WeeklyEvaluationsCubit(this.repo, this.assignmentsRepo)
    : super(WeeklyEvaluationsInitial());

  final WeeklyEvaluationsRepo repo;
  final AssignmentsRepo assignmentsRepo;
  String role = '';
  PlanClassroomOption? selectedClassroom;
  List<int> availableWeeks = const [];
  int? selectedWeek;
  int? currentWeek;
  WeeklyEvaluationsResponseModel? response;
  List<ParentPlanChildModel> children = const [];
  String? selectedChildId;
  List<WeeklyEvaluationStudentModel> formStudents = const [];
  List<EvaluationSubjectModel> formSubjects = const [];
  String? formClassroomId, formStudentId;
  int _requestId = 0;
  int _formRequestId = 0;
  String? _classroomsSignature;
  bool _isSaving = false;

  bool get canManage => role == 'teacher' || role == 'supervisor';
  bool get isTeacher => role == 'teacher';
  bool get isParent => role == 'parent';
  bool get hasMultipleChildren => children.length > 1;

  Future<void> initialize(String? userRole) async {
    role = userRole?.trim().toLowerCase() ?? '';
    if (isParent) await _loadChildren();
  }

  Future<void> setClassrooms(List<PlanClassroomOption> classrooms) async {
    final signature = classrooms.map((item) => item.id).join('|');
    if (signature == _classroomsSignature) return;
    _classroomsSignature = signature;
    if (classrooms.isEmpty) {
      _clearSelection();
      emit(EvaluationsEmpty());
      return;
    }
    final currentId = selectedClassroom?.id;
    final next = classrooms.where((item) => item.id == currentId).firstOrNull;
    await selectClassroom(next ?? classrooms.first);
  }

  Future<void> selectClassroom(PlanClassroomOption? classroom) async {
    if (classroom == null || classroom.id.trim().isEmpty) return;
    if (selectedClassroom?.id == classroom.id && availableWeeks.isNotEmpty) {
      return;
    }
    selectedClassroom = classroom;
    await _loadWeeks();
  }

  Future<void> selectWeek(int? week) async {
    if (week == null || !availableWeeks.contains(week)) return;
    if (selectedWeek == week && response != null) return;
    selectedWeek = week;
    await _loadEvaluations(++_requestId);
  }

  Future<void> selectChild(String? childId) async {
    if (childId == null || childId == selectedChildId) return;
    final child = children.where((item) => item.id == childId).firstOrNull;
    if (child == null) return;
    selectedChildId = child.id;
    final classroom = child.classroom;
    if (classroom == null || classroom.id.trim().isEmpty) {
      _clearEvaluationData();
      emit(const EvaluationsFailure('Child classroom is unavailable'));
      return;
    }
    selectedClassroom = PlanClassroomOption(
      id: classroom.id,
      name: classroom.name,
    );
    await _loadWeeks();
  }

  Future<void> retry() async {
    if (selectedClassroom == null) {
      if (isParent) await _loadChildren();
      return;
    }
    if (availableWeeks.isEmpty) {
      await _loadWeeks();
    } else {
      await _loadEvaluations(++_requestId);
    }
  }

  Future<bool> upsert(UpsertEvaluationRequestModel request) async {
    if (_isSaving || isClosed || !_isValidRequest(request)) return false;
    _isSaving = true;
    emit(EvaluationSaving());
    try {
      final result = await repo.upsert(request);
      if (isClosed) return false;
      var saved = false;
      result.fold((failure) => emit(EvaluationSaveFailure(failure.message)), (
        _,
      ) {
        saved = true;
        emit(EvaluationSaved());
      });
      if (saved) await _loadEvaluations(++_requestId, keepData: true);
      return saved;
    } finally {
      _isSaving = false;
    }
  }

  void clearFormOptions() {
    _formRequestId++;
    formClassroomId = null;
    formStudentId = null;
    formStudents = const [];
    formSubjects = const [];
  }

  Future<void> loadFormStudents(String classroomId) async {
    final requestId = ++_formRequestId;
    formClassroomId = classroomId;
    formStudentId = null;
    formStudents = const [];
    formSubjects = const [];
    emit(EvaluationStudentsLoading());
    final result = await repo.getClassroomStudents(classroomId);
    if (!_isCurrentForm(requestId, classroomId)) return;
    result.fold((failure) => emit(EvaluationOptionsFailure(failure.message)), (
      students,
    ) {
      formStudents = students;
      emit(EvaluationStudentsLoaded());
    });
  }

  Future<void> loadFormSubjects({
    required String classroomId,
    required String studentId,
  }) async {
    final requestId = ++_formRequestId;
    formClassroomId = classroomId;
    formStudentId = studentId;
    formSubjects = const [];
    emit(EvaluationSubjectsLoading());
    final result = await repo.getStudentSubjects(
      classroomId: classroomId,
      studentId: studentId,
    );
    if (!_isCurrentForm(requestId, classroomId, studentId)) return;
    List<EvaluationSubjectModel>? available;
    result.fold(
      (failure) => emit(EvaluationOptionsFailure(failure.message)),
      (subjects) => available = subjects,
    );
    if (available == null) return;
    if (!isTeacher) {
      formSubjects = available!;
      emit(EvaluationSubjectsLoaded());
      return;
    }
    final assignedResult = await assignmentsRepo.getTeacherAssignedSubjects(
      classroomId: classroomId,
    );
    if (!_isCurrentForm(requestId, classroomId, studentId)) return;
    assignedResult.fold(
      (failure) => emit(EvaluationOptionsFailure(failure.message)),
      (response) {
        final assignedIds = response.data.subjects
            .map((item) => item.id)
            .toSet();
        formSubjects = available!
            .where((subject) => assignedIds.contains(subject.id))
            .toList(growable: false);
        emit(EvaluationSubjectsLoaded());
      },
    );
  }

  Future<void> retryFormOptions() async {
    final classroomId = formClassroomId;
    if (classroomId == null) return;
    final studentId = formStudentId;
    if (studentId == null) return loadFormStudents(classroomId);
    return loadFormSubjects(classroomId: classroomId, studentId: studentId);
  }

  Future<void> _loadChildren() async {
    final requestId = ++_requestId;
    emit(ParentChildrenLoading());
    final result = await repo.getParentChildren();
    if (!_isCurrent(requestId)) return;
    await result.fold(
      (failure) async => emit(EvaluationsFailure(failure.message)),
      (value) async {
        children = value.data;
        if (children.isEmpty) return emit(EvaluationsEmpty());
        selectedChildId = children.first.id;
        final classroom = children.first.classroom;
        if (classroom == null || classroom.id.trim().isEmpty) {
          return emit(
            const EvaluationsFailure('Child classroom is unavailable'),
          );
        }
        selectedClassroom = PlanClassroomOption(
          id: classroom.id,
          name: classroom.name,
        );
        await _loadWeeks();
      },
    );
  }

  Future<void> _loadWeeks() async {
    final classroom = selectedClassroom;
    if (classroom == null) return;
    final requestId = ++_requestId;
    _clearEvaluationData();
    emit(EvaluationWeeksLoading());
    final result = await repo.getElapsedWeeks(classroom.id);
    if (!_isCurrent(requestId) || selectedClassroom?.id != classroom.id) return;
    await result.fold(
      (failure) async => emit(EvaluationsFailure(failure.message)),
      (value) async {
        availableWeeks = value.data.weeks;
        currentWeek = value.data.currentWeek;
        selectedWeek = value.data.initialWeek;
        if (selectedWeek == null) return emit(EvaluationsEmpty());
        await _loadEvaluations(requestId);
      },
    );
  }

  Future<void> _loadEvaluations(int requestId, {bool keepData = false}) async {
    final classroom = selectedClassroom;
    final week = selectedWeek;
    if (classroom == null || week == null) return;
    if (!keepData) response = null;
    emit(EvaluationsLoading());
    final result = canManage
        ? await repo.getClassroomWeekly(classroomId: classroom.id, week: week)
        : await repo.getMyEvaluations(
            week: week,
            studentId: isParent && hasMultipleChildren ? selectedChildId : null,
          );
    if (!_isCurrent(requestId) || selectedWeek != week) return;
    result.fold((failure) => emit(EvaluationsFailure(failure.message)), (
      value,
    ) {
      response = value;
      emit(
        value.data.students.isEmpty ? EvaluationsEmpty() : EvaluationsLoaded(),
      );
    });
  }

  void _clearEvaluationData() {
    response = null;
    availableWeeks = const [];
    selectedWeek = null;
    currentWeek = null;
  }

  void _clearSelection() {
    selectedClassroom = null;
    _clearEvaluationData();
  }

  bool _isCurrent(int requestId) => !isClosed && requestId == _requestId;

  bool _isValidRequest(UpsertEvaluationRequestModel request) =>
      request.student.trim().isNotEmpty &&
      request.classroom.trim().isNotEmpty &&
      request.subject.trim().isNotEmpty &&
      request.week > 0 &&
      request.attendance.trim().isNotEmpty &&
      request.participation.trim().isNotEmpty &&
      request.homework.trim().isNotEmpty &&
      request.behavior.trim().isNotEmpty;

  bool _isCurrentForm(int requestId, String classroomId, [String? studentId]) =>
      !isClosed &&
      requestId == _formRequestId &&
      formClassroomId == classroomId &&
      formStudentId == studentId;
}
