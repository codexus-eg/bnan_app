import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:bnan_app/features/attendance/data/repo/attendance_repo.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this.repo) : super(const AttendanceState());
  final AttendanceRepo repo;
  UserRole? _role;
  int _sessionsGeneration = 0, _studentsGeneration = 0;

  Future<void> initialize(UserRole? role) async {
    _role = role;
    if (role != UserRole.teacher && role != UserRole.supervisor) {
      emit(state.copyWith(allowed: false));
      return;
    }
    emit(state.copyWith(loadingClassrooms: true, errorMessage: null));
    final result = await repo.getAllowedClassrooms(role!);
    if (isClosed || role != _role) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingClassrooms: false,
          errorMessage: failure.message,
          errorTarget: AttendanceLoadTarget.classrooms,
        ),
      ),
      (classrooms) {
        final grades = {
          for (final item in classrooms) item.grade.id: item.grade,
        }.values.toList();
        emit(
          state.copyWith(
            classrooms: classrooms,
            grades: grades,
            loadingClassrooms: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void selectGrade(String? gradeId) {
    _sessionsGeneration++;
    _studentsGeneration++;
    emit(
      state.copyWith(
        gradeId: gradeId,
        classroomId: null,
        sessionId: null,
        sessions: const [],
        students: const [],
        statuses: const {},
        loadingSessions: false,
        loadingStudents: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> selectClassroom(String? classroomId) async {
    final generation = ++_sessionsGeneration;
    _studentsGeneration++;
    emit(
      state.copyWith(
        classroomId: classroomId,
        sessionId: null,
        sessions: const [],
        students: const [],
        statuses: const {},
        loadingSessions: classroomId != null,
        loadingStudents: false,
        errorMessage: null,
      ),
    );
    if (classroomId == null) return;
    final result = await repo.getSessions(classroomId);
    if (!_currentClassroom(generation, classroomId)) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingSessions: false,
          errorMessage: failure.message,
          errorTarget: AttendanceLoadTarget.sessions,
        ),
      ),
      (sessions) => emit(
        state.copyWith(
          sessions: sessions,
          loadingSessions: false,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> selectSession(String? sessionId) async {
    final classroomId = state.selectedClassroomId;
    final generation = ++_studentsGeneration;
    emit(
      state.copyWith(
        sessionId: sessionId,
        students: const [],
        statuses: const {},
        loadingStudents: sessionId != null && classroomId != null,
        errorMessage: null,
      ),
    );
    if (sessionId == null || classroomId == null) return;
    final result = await repo.getStudents(classroomId);
    if (!_currentSession(generation, classroomId, sessionId)) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingStudents: false,
          errorMessage: failure.message,
          errorTarget: AttendanceLoadTarget.students,
        ),
      ),
      (students) => emit(
        state.copyWith(
          students: students,
          statuses: {
            for (final student in students)
              student.id: AttendanceStatus.present,
          },
          loadingStudents: false,
          errorMessage: null,
        ),
      ),
    );
  }

  void updateStatus(String studentId, AttendanceStatus status) {
    if (!state.statusByStudentId.containsKey(studentId)) return;
    emit(
      state.copyWith(statuses: {...state.statusByStudentId, studentId: status}),
    );
  }

  Future<bool> submit() async {
    if (state.submitting) return false;
    final sessionId = state.selectedSessionId;
    if (sessionId == null || sessionId.isEmpty || state.students.isEmpty) {
      return false;
    }
    final request = BulkAttendanceRequest(
      sessionId: sessionId,
      students: state.students.map(
        (student) => AttendanceStudentInput(
          studentId: student.id,
          status:
              state.statusByStudentId[student.id] ?? AttendanceStatus.present,
        ),
      ),
    );
    if (request.students.isEmpty) return false;
    emit(state.copyWith(submitting: true));
    final result = await repo.submitBulk(request);
    if (isClosed) return false;
    var success = false;
    result.fold((failure) => _event(failure.message, false), (records) {
      success = true;
      final statuses = {...state.statusByStudentId};
      for (final record in records) {
        if (statuses.containsKey(record.studentId)) {
          statuses[record.studentId] = record.status;
        }
      }
      emit(state.copyWith(statuses: statuses, submitting: false));
      _event(S.current.attendanceRegisteredSuccessfully, true);
    });
    return success;
  }

  Future<void> retry() async {
    switch (state.errorTarget) {
      case AttendanceLoadTarget.classrooms:
        return initialize(_role);
      case AttendanceLoadTarget.sessions:
        return selectClassroom(state.selectedClassroomId);
      case AttendanceLoadTarget.students:
        return selectSession(state.selectedSessionId);
      case AttendanceLoadTarget.none:
        return;
    }
  }

  void _event(String message, bool success) => emit(
    state.copyWith(
      submitting: false,
      eventMessage: message,
      eventSuccess: success,
      eventId: state.eventId + 1,
    ),
  );
  bool _currentClassroom(int generation, String id) =>
      !isClosed &&
      generation == _sessionsGeneration &&
      state.selectedClassroomId == id;
  bool _currentSession(int generation, String classroomId, String sessionId) =>
      !isClosed &&
      generation == _studentsGeneration &&
      state.selectedClassroomId == classroomId &&
      state.selectedSessionId == sessionId;
}
